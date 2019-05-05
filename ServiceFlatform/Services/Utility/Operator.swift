//
//  Operator.swift
//  ServicePlatform
//
//

import RxSwift
import RxCocoa

// MARK: - Operator overloading
/// Rx two-ways binding
infix operator <->: AdditionPrecedence
/// Function injection
infix operator |>: AdditionPrecedence

/// MARK: Implementions |>
public func |><A, B> (f: (A) -> B, arg: A) -> B {
  return f(arg)
}

public func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

public func |> <A> (f: (A) -> Void, arg: A){
  f(arg)
}

public func |><A>(f: ()->(A)->Void, arg: A) {
  f() |> arg
}

public func |><A,B>(f: (A)->(B)->Void, arg: A) -> (B) -> () {
  return f(arg)
}

public func maxx<T: Comparable>(lhs: T, rhs: T) -> T {
  return lhs > rhs ? lhs : rhs
}

public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?): return l < r
  case (nil, _?): return true
  default: return false
  }
}

public func nonMarkedText(_ textInput: UITextInput) -> String? {
  let start = textInput.beginningOfDocument
  let end = textInput.endOfDocument

  guard let rangeAll = textInput.textRange(from: start, to: end),
    let text = textInput.text(in: rangeAll) else {
      return nil
  }

  guard let markedTextRange = textInput.markedTextRange else {
    return text
  }

  guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
    let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
      return text
  }

  return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

// MARK: - Implementations <->
public func <-> <Base>(textInput: TextInput<Base>, variable: Variable<String>) -> Disposable {
  let bindToUIDisposable = variable.asObservable()
    .bind(to: textInput.text)
  let bindToVariable = textInput.text
    .subscribe(onNext: { [weak base = textInput.base] n in
      guard let base = base else {
        return
      }

      let nonMarkedTextValue = nonMarkedText(base)

      /**
       In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
       value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
       The can be reproed easily if replace bottom code with

       if nonMarkedTextValue != variable.value {
       variable.value = nonMarkedTextValue ?? ""
       }

       and you hit "Done" button on keyboard.
       */
      if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
        variable.value = nonMarkedTextValue
      }
      }, onCompleted:  {
        bindToUIDisposable.dispose()
    })

  return Disposables.create(bindToUIDisposable, bindToVariable)
}

public func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {

  let bindToUIDisposable = variable.asObservable()
    .bind(to: property)
  let bindToVariable = property
    .subscribe(onNext: { n in
      variable.value = n
    }, onCompleted:  {
      bindToUIDisposable.dispose()
    })

  return Disposables.create(bindToUIDisposable, bindToVariable)
}
