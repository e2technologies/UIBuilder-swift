//
//  UIBuilder.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilder {
    public static func stack(horizontal elements: [UIBuilderElement]) -> UIBuilderElement {
        return UIBuilderStack(elements: elements, mode: .horizontal)
    }
    
    public static func stack(vertical elements: [UIBuilderElement]) -> UIBuilderElement {
        return UIBuilderStack(elements: elements, mode: .vertical)
    }
}
