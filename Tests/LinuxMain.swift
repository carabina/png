@testable import MaxPNGTests
@testable import MaxPNG
import Glibc

let interlace_test_ref:String = "interlace.rgba",
    interlace_test_in:String = "interlace.png",
    interlace_test_out:String = "interlace_deinterlace.png",
    image_test_ref:String = "taylor.rgba",
    image_test_in:String = "taylor.png",
    image_test_out:String = "taylor_reconverted.png"

var passed:Bool = true

//let data:[RGBA<UInt16>] = load_rgb_data(absolute_path: absolute_unix_path("Tests/MaxPNGTests/unit/basi0g04.rgba"), npixels: 32*32)
//print(data)

run_tests(test_cases: test_cases)

try encode_png(path: "Tests/output.png",
               raw_data: [0, 0, 0, 255, 255, 255, 255, 0, 255,
                          255, 255, 255, 0, 0, 0, 0, 255, 0,
                          120, 120, 255, 150, 120, 255, 180, 120, 255],
               properties: PNGProperties(width: 3, height: 3, bit_depth: 8, color: .rgb, interlaced: false)!)

passed = passed && test_decompose_and_deinterlace(path: "Tests/interlace", index: 0)

try reencode_png("Tests/" + image_test_in, output: "Tests/" + image_test_out)



print("Testing images \(image_test_ref) == \(image_test_out)")
if test_decoded_identical(path_png: "Tests/" + image_test_out, path_rgba: "Tests/" + image_test_ref)
{
    print("images identical")
    passed = passed && true
}
else
{
    print("images not identical")
    passed = false
}

print("Testing images \(interlace_test_ref) == \(interlace_test_out)")
if test_decoded_identical(path_png: "Tests/" + interlace_test_out, path_rgba: "Tests/" + interlace_test_ref)
{
    print("images identical")
    passed = passed && true
}
else
{
    print("images not identical")
    passed = false
}

exit(passed ? 0 : 1)
