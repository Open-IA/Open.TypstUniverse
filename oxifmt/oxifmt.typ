// From Typst 0.8.0, a break change has been released: a type is now itself a
// value and type checks now are of the form 'type(10) == int' not the old
// style 'type(10) == "integer"'
//
// [+] See: https://github.com/typst/typst/releases/tag/v0.8.0

#let _int-type    = type(0)
#let _float-type  = type(5.5)
#let _str-type    = type("")
#let _label-type  = type(<hello>)
#let _arr-type    = type(())

#let _minus-sign = "\u{2212}"

#let using-080 = type(type(5)) != _str-type
#let using-090 = using-080 and str(-1).codepoints().first() == _minus-sign
#let using-0110 = using-080 and sys.version >= version(0, 11, 0)
#let using-0120 = using-0110 and sys.version >= version(0, 12, 0)

// Decimal is a fixed-point decimal number type. This type should be used for
// precise arithmetic operations on numbers represented in base 10.
//
// This break change is released by Typst 0.12.0
//
// [+] See: https://typst.app/docs/changelog/0.12.0/

#let _decimal = if using-0120 { decimal } else { none }

// `array.chunks` is a method to split an array into non-overlapping chunks,
// starting at the beginning, ending with a single remainder chunk. All chunks
// but the last one have `chunk-size` elements.
//
// This new method is introduced by Typst 0.11.0
//
// [+] See: https://github.com/typst/typst/releases/tag/v0.11.0

#let _array-chunks = if using-0110 {
  array.chunks
} else {
  (arr, chunk-size) => {
    let i = 0
    let result = ()
    for element in arr {
      if i == 0 {
        result.push(())
        i = chunk-size
      }
      result.last().push(element)
      i -= 1
    }
    result
  }
}

// Docstring of functions in Typst should follow the supported syntax of Tinymist
//
// [+] See: https://myriad-dreamin.github.io/tinymist/feature/docs.html

/// Splits an array into dynamic chunk sizes.
///
/// 'chunks' is an array like (1, 2, 3) indicating the sizes of each chunk. The
/// last size is repeated if there are more elements than the chunks combined
/// can cover.
///
/// For example, if the array is (1, 2, 3, 4, 1, 2, 0, 9) and the chunk is
/// (1, 2, 3), then result is
/// 
/// ((1), (2, 3), (4, 1, 2), (0, 9))
///
/// -> array
/// - arr (array): The input array of function `_arr-dyn-chunks`
/// - chunks (array): Chunk array of this function
#let _arr-dyn-chunks(arr, chunks) = {
  let i = 0
  let result = ()
  let chunk-index = 0

  if chunks == () {
    return ()
  }

  for element in arr {
    if i == 0 {
      result.push(())
      i = chunks.at(chunk-index)
      if i <= 0 {
        assert(
          false,
          message: "String formatter error: internal error: received chunk of invalid size"
        )
        if chunk-index + 1 != chunks.len() {
          chunk-index += 1
        }
      }
    }
    result.last().push(element)
    i -= 1
  }
  result
}

#let _float-is-nan = if using-0110 {
  float.is-nan
} else {
  x => type(x) == _float-type and "NaN" in repr(x)
}

#let _float-is-infinite = if using-0110 {
  float.is-infinite
} else {
  x => type(x) == _float-type and "inf" in repr(x)
}
