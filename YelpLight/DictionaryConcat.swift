//
//  DictionaryConcat.swift
//  YelpLight
//
//  Created by Shane Afsar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
  return left
}