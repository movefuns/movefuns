/// Provides a way for comparing two elements of same type
module movefuns::comparator {
  use std::bcs;
  use std::vector;
  
  #[test_only]
  use std::string::{String};
  #[test_only]
  use std::string;
  
  const EQUAL: u8 = 0;
  const MORE: u8 = 1;
  const LESS: u8 = 2;

  public fun more_than<T>(left: &T, right: &T): bool {
    compare(left, right) == MORE
  }
  
  public fun less_than<T>(left: &T, right: &T): bool {
    compare(left, right) == LESS
  }
  
  public fun equal<T>(left: &T, right: &T): bool {
    compare(left, right) == EQUAL
  }
  
  public fun no_more_than<T>(left: &T, right: &T): bool {
    compare(left, right) != MORE
  }
  
  public fun no_less_than<T>(left: &T, right: &T): bool {
    compare(left, right) != LESS
  }
  
  // Performs comparison after BCS serialization.
  fun compare<T>(left: &T, right: &T): u8 {
    let left_bytes = bcs::to_bytes(left);
    let right_bytes = bcs::to_bytes(right);
    compare_u8_vector(left_bytes, right_bytes)
  }

  // Performs a comparison of two vector<u8>s or byte vectors
  fun compare_u8_vector(left: vector<u8>, right: vector<u8>): u8 {
    let left_length = vector::length(&left);
    let right_length = vector::length(&right);

    let idx = 0;

    while (idx < left_length && idx < right_length) {
      let left_byte = *vector::borrow(&left, idx);
      let right_byte = *vector::borrow(&right, idx);

      if (left_byte < right_byte) {
        return LESS
      } else if (left_byte > right_byte) {
        return MORE
      };
        idx = idx + 1;
      };

      if (left_length < right_length) {
        LESS
      } else if (left_length > right_length) {
        MORE
      } else {
        EQUAL
      }
    }

  #[test]
  fun test_strings() {
    use std::string;

    let str0 = string::utf8(b"aaa");
    let str1 = string::utf8(b"aaa");
    let str2 = string::utf8(b"aab");
    let str3 = string::utf8(b"aabc");

    assert!(compare(&str0, &str1) == EQUAL, 0);
    assert!(compare(&str1, &str2) == LESS, 0);
    assert!(compare(&str3, &str2) == MORE, 0);
  }

  #[test]
  fun test_u128() {
    let value0: u128 = 0;
    let value1: u128 = 0;
    let value2: u128 = 333;
    let value3: u128 = 888;
    
    assert!(compare(&value0, &value1) == EQUAL, 0);
    assert!(compare(&value1, &value2) == LESS, 0);
    assert!(compare(&value3, &value2) == MORE, 0);
  }

  #[test_only]
  struct Complex has drop {
    name: String
  }

  #[test]
  fun test_complex() {
    let comp0 = Complex {
      name: string::utf8(b"aaa")
    };
    let comp1 = Complex {
      name: string::utf8(b"aaa")
    };
    let comp2 = Complex {
      name: string::utf8(b"aab")
    };
    let comp3 = Complex {
      name: string::utf8(b"aabc")
    };
    
    assert!(compare(&comp0, &comp1) == EQUAL, 0);
    assert!(compare(&comp1, &comp2) == LESS, 0);
    assert!(compare(&comp3, &comp2) == MORE, 0);
  }
}
