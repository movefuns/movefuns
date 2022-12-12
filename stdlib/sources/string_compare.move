/// Provides a way for comparing two strings
module movefuns::string_compare {
  use std::bcs;
  use std::vector;
  use std::string::String;
  
  const EQUAL: u8 = 0;
  const GREATER: u8 = 1;
  const LESS: u8 = 2;
  
  public fun greater_than(left: &String, right: &String): bool {
    string_compare(left, right) == GREATER
  }
  
  public fun less_than(left: &String, right: &String): bool {
    string_compare(left, right) == LESS
  }
  
  public fun equal(left: &String, right: &String): bool {
    string_compare(left, right) == EQUAL
  }
  
  public fun no_greater_than(left: &String, right: &String): bool {
    string_compare(left, right) != GREATER
  }
  
  public fun no_less_than(left: &String, right: &String): bool {
    string_compare(left, right) != LESS
  }
  
  // Performs comparison after BCS serialization.
  fun string_compare(left: &String, right: &String): u8 {
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
        return GREATER
      };
      idx = idx + 1;
    };
    
    if (left_length < right_length) {
      LESS
    } else if (left_length > right_length) {
      GREATER
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
    
    assert!(string_compare(&str0, &str1) == EQUAL, 0);
    assert!(string_compare(&str1, &str2) == LESS, 0);
    assert!(string_compare(&str3, &str2) == GREATER, 0);
  }
}
