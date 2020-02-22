import XCTest

import imgcopyTests
import ImgCopyModTests

var tests = [XCTestCaseEntry]()

tests += ClipBoardTest.allTests()
tests += TargetFileTest.allTests()

tests += imgcopyTests.allTests()
XCTMain(tests)
