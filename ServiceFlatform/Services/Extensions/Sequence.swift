//
//  Sequence.swift
//  ServicePlatform
//
//

import Foundation

public extension Sequence {

  public func categorise<U, E>(dict: inout [U:[E]], _ key: (Iterator.Element) -> U, _ element: (Iterator.Element) -> E) {
    for el in self {
      let key = key(el)
      if case nil = dict[key]?.append(element(el)) { dict[key] = [element(el)] }
    }
  }

  public func find(_ find: (Iterator.Element) -> Bool) -> Iterator.Element? {
    for it in self where find(it) { return it }
    return nil
  }

  public func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
    var categories: [U: [Iterator.Element]] = [:]
    for element in self {
      let key = key(element)
      if case nil = categories[key]?.append(element) {
        categories[key] = [element]
      }
    }
    return categories
  }
}

// MARK: - Array
public extension Array {

  // MARK: - Custom functions
  public func findRev(_ find: (Element) -> Bool) -> Element? {
    for it in self.reversed() where find(it) { return it }
    return nil
  }

  public func unique(filter: ([Element], Element) -> Bool) -> [Element] {
    return reduce([], { (res, item) in !filter(res, item) ? res + [item] : res })
  }

  public func find(_ find: (Element) -> Bool) -> Element? {
    for it in self where find(it) { return it }
    return nil
  }
}

extension Array where Element: Hashable {
  public func uniqued() -> [Element] {
    var seen = Set<Element>()
    return filter{ seen.insert($0).inserted }
  }
}

public extension Array where Element: Equatable {

  public func contains(_ objs: [Element]) -> Bool {
    return !objs.contains { !self.contains($0) }
  }

  public func containsAnyOf(_ objs: [Element]) -> Bool {
    for it in objs where self.contains(it) { return true }
    return false
  }
}

//MARK: - Compare arrays
public struct SequenceDiff<T1, T2> {
  public let common: [(T1, T2)]
  public let removed: [T1]
  public let inserted: [T2]
  public init(common: [(T1, T2)] = [], removed: [T1] = [], inserted: [T2] = []) {
    self.common = common
    self.removed = removed
    self.inserted = inserted
  }
}

public func diff<T1, T2>(_ first: [T1], _ second: [T2], with compare: (T1,T2) -> Bool) -> SequenceDiff<T1, T2> {
  let combinations = first.compactMap { firstElement in (firstElement, second.first { secondElement in compare(firstElement, secondElement) }) }
  let common = combinations.filter { $0.1 != nil }.compactMap { ($0.0, $0.1!) }
  let removed = combinations.filter { $0.1 == nil }.compactMap { ($0.0) }
  let inserted = second.filter { secondElement in !common.contains { compare($0.0, secondElement) } }
  
  return SequenceDiff(common: common, removed: removed, inserted: inserted)
}
