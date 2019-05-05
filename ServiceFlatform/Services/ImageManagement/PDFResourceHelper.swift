//
//  PDFResourceHelper.swift
//  WAPersonal
//
//  Created by Roman Bambura on 2/25/16.
//  Copyright © 2016 Roman Bambura. All rights reserved.
//

import UIKit

public class PDFResourceHelper {

  public static func resourceURLForName(_ resourceName: String?) -> URL? {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    if let path = directoryURLs.first, let resourceName = resourceName {
      return path.appendingPathComponent(resourceName)
    }
    return nil
  }

  public static func mediaRect(_ resourceName: String?) -> CGRect {
    return self.mediaRectForURL(self.resourceURLForName(resourceName)!)
  }

  public static func mediaRectForURL(_ resourceURL: URL) -> CGRect {
    return mediaRectForURL(resourceURL, page:1)
  }

  public static func mediaRectForURL(_ resourceURL: URL?,  page: Int)-> CGRect{

    var rect:CGRect = CGRect.null

    if let resourceURL = resourceURL, let pdf: CGPDFDocument = CGPDFDocument(resourceURL as CFURL) {
      if let page1:CGPDFPage = pdf.page(at: page) {
        rect = page1.getBoxRect(CGPDFBox.cropBox)
        let rotationAngle = page1.rotationAngle

        if (rotationAngle == 90 || rotationAngle == 270) {
          let temp = rect.size.width
          rect.size.width = rect.size.height
          rect.size.height = temp
        }
      }
    }
    return rect;
  }

  public static func renderIntoContext(_ ctx: CGContext,  url resourceURL: URL?, data resourceData:Data?, size: CGSize, page:Int, preserveAspectRatio:Bool){

    var document: CGPDFDocument?

    if let resourceURL = resourceURL {
      document = CGPDFDocument( resourceURL as CFURL )
    } else if let resourceData = resourceData {
      if let provider: CGDataProvider = CGDataProvider( data: resourceData as CFData ) {
        document = CGPDFDocument( provider )!
      }
    }

    if let page1: CGPDFPage = document?.page(at: page ){
      let destRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

      let drawingTransform: CGAffineTransform = page1.getDrawingTransform(CGPDFBox.cropBox, rect: destRect, rotate: 0, preserveAspectRatio: preserveAspectRatio);
      ctx.concatenate(drawingTransform)
      ctx.drawPDFPage(page1 )
    }
  }

  public static func mediaRectForData(_ data: Data?,  page: Int) -> CGRect{

    var rect:CGRect = CGRect.null

    if let data = data, let provider: CGDataProvider = CGDataProvider( data: data as CFData ) {
      if let document:CGPDFDocument = CGPDFDocument( provider ){
        if let page1:CGPDFPage = document.page(at: page ) {
          rect = page1.getBoxRect(CGPDFBox.cropBox )
          let rotationAngle = page1.rotationAngle

          if (rotationAngle == 90 || rotationAngle == 270) {
            let temp = rect.size.width
            rect.size.width = rect.size.height
            rect.size.height = temp
          }
        }
      }
    }

    return rect;
  }
}
