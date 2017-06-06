import PromiseKit
import XCTest

class PromiseTupleTests: XCTestCase {

    /// test then tuples

    func testThenReturningDoublePromisesTuple() {
        let ex = expectation(description: "promise tuple values returned")
        getPromises { (arg) in
            
            let (a, b, _, _, _, first) = arg
            first.then { () -> (Promise<Bool>, Promise<Int>) in
                return (a, b)
            }.then { (bool, integer) -> Void in
                XCTAssertEqual(a.value, bool)
                XCTAssertEqual(b.value, integer)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testThenReturningTriplePromisesTuple() {
        let ex = expectation(description: "promise tuple values returned")

        getPromises() { (arg) in
            
            let (a, b, c, _, _, first) = arg
            first.then { () -> (Promise<Bool>, Promise<Int>, Promise<String>) in
                return (a, b, c)
            }.then { aVal, bVal, cVal -> Void in
                XCTAssertEqual(a.value, aVal)
                XCTAssertEqual(b.value, bVal)
                XCTAssertEqual(c.value, cVal)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testThenReturningQuadruplePromisesTuple() {
        let ex = expectation(description: "promise tuple values returned")

        getPromises() { (arg) in
            
            let (a, b, c, d, _, first) = arg
            first.then { () -> (Promise<Bool>, Promise<Int>, Promise<String>, Promise<(Int, Int)>) in
                return (a, b, c, d)
            }.then { (boolean, integer, string, integerTuple) -> Void in
                XCTAssertEqual(a.value, boolean)
                XCTAssertEqual(b.value, integer)
                XCTAssertEqual(c.value, string)
                XCTAssertEqual(d.value!.0, integerTuple.0)
                XCTAssertEqual(d.value!.1, integerTuple.1)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testThenReturningQuintuplePromisesTuple() {
        let ex = expectation(description: "promise tuple values returned")

        getPromises { (arg) in
            
            let (a, b, c, d, e, first) = arg
            first.then { () -> (Promise<Bool>, Promise<Int>, Promise<String>, Promise<(Int, Int)>, Promise<Double>) in
                return (a, b, c, d, e)
            }.then { (boolean, integer, string, integerTuple, double) -> Void in
                XCTAssertEqual(a.value, boolean)
                XCTAssertEqual(b.value, integer)
                XCTAssertEqual(c.value, string)
                XCTAssertEqual(d.value!.0, integerTuple.0)
                XCTAssertEqual(d.value!.1, integerTuple.1)
                XCTAssertEqual(e.value, double)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    // test then tuples fail

    func testThenNtuplePromisesFail(generator: (Promise<Void>, Promise<Any>, Promise<Any>) -> Promise<Void>) {
        let ex = expectation(description: "")

        generator(after(interval: 0.1), Promise<Any>(value: 1), Promise<Any>(error: TestError.sthWrong)).then { _ in
            XCTFail("Then called instead of `catch`")
        }.catch { e in
            if case TestError.sthWrong = e {
                ex.fulfill()
            } else {
                XCTFail("Wrong error received")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testThenDoublePromisesTupleFail() {
        testThenNtuplePromisesFail { after, success, err in
            after.then { _ in (err, success) }
                 .then { (_) in () }
        }
    }

    func testThenTriplePromisesTupleFail() {
        testThenNtuplePromisesFail { after, success, err in
            after.then { _ in (success, err, success) }
                .then { (_) in () }
        }
    }

    func testThenQuadruplePromisesTupleFail() {
        testThenNtuplePromisesFail { after, success, err in
            after.then { _ in (err, err, err, success) }
                .then { (_) in () }
        }
    }

    func testThenQuintuplePromisesTupleFail() {
        testThenNtuplePromisesFail { after, success, err in
            after.then { _ in (success, success, err, err, success) }
                .then { (_) in () }
        }
    }

    // test firstly tuples

    func testFirstlyReturningPromise() {
        let ex = expectation(description: "promise tuple values returned")

        firstly { () -> Promise<Bool> in
            return Promise(value: true)
        }.then { val -> Void in
            XCTAssertEqual(val, true)
            ex.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFirstlyReturningDoublePromisesTuple() {

        let ex = expectation(description: "promise tuple values returned")

        getPromises { (arg) in
            
            let (a, b, _, _, _, _) = arg
            firstly { () -> (Promise<Bool>, Promise<Int>) in
                return (a, b)
            }.then { (arg: (Bool, Int)) -> Void in
                
                let (aVal, bVal) = arg
                XCTAssertEqual(aVal, a.value)
                XCTAssertEqual(bVal, b.value)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFirstlyReturningTriplePromisesTuple() {

        let ex = expectation(description: "promise tuple values returned")

        getPromises { (arg) in
            
            let (a, b, c, _, _, _) = arg
            firstly { () -> (Promise<Bool>, Promise<Int>, Promise<String>) in
                return (a, b, c)
            }.then { (arg: (Bool, Int, String)) -> Void in
                
                let (aVal, bVal, cVal) = arg
                XCTAssertEqual(aVal, a.value)
                XCTAssertEqual(bVal, b.value)
                XCTAssertEqual(cVal, c.value)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFirstlyReturningQuadruplePromisesTuple() {

        let ex = expectation(description: "promise tuple values returned")

        getPromises { (arg) in
            
            let (a, b, c, d, _, _) = arg
            firstly { () -> (Promise<Bool>, Promise<Int>, Promise<String>, Promise<(Int, Int)>) in
                return (a, b, c, d)
            }.then { (arg: (Bool, Int, String, (Int, Int))) -> Void in
                
                let (aVal, bVal, cVal, dVal) = arg
                XCTAssertEqual(aVal, a.value)
                XCTAssertEqual(bVal, b.value)
                XCTAssertEqual(cVal, c.value)
                XCTAssertEqual(dVal.0, d.value!.0)
                XCTAssertEqual(dVal.1, d.value!.1)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }


    func testFirstlyReturningQuintuplePromisesTuple() {

        let ex = expectation(description: "promise tuple values returned")

        getPromises { (arg) in
            
            let (a, b, c, d, e, _) = arg
            firstly { () -> (Promise<Bool>, Promise<Int>, Promise<String>, Promise<(Int, Int)>, Promise<Double>) in
                return (a, b, c, d, e)
            }.then { (arg: (Bool, Int, String, (Int, Int), Double)) -> Void in
                
                let (aVal, bVal, cVal, dVal, eVal) = arg
                XCTAssertEqual(aVal, a.value)
                XCTAssertEqual(bVal, b.value)
                XCTAssertEqual(cVal, c.value)
                XCTAssertEqual(dVal.0, d.value!.0)
                XCTAssertEqual(dVal.1, d.value!.1)
                XCTAssertEqual(eVal, e.value)
                ex.fulfill()
            }

        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    // test firstly fail
    func testFirstlyNtuplePromisesFail(generator: (Promise<Void>, Promise<Any>, Promise<Any>) -> Promise<Void>) {
        let ex = expectation(description: "")

        generator(after(interval: 0.1), Promise<Any>(value: 1), Promise<Any>(error: TestError.sthWrong)).then {_ in 
            XCTFail("Then called instead of `catch`")
        }.catch { e in
            if case TestError.sthWrong = e {
                ex.fulfill()
            } else {
                XCTFail("Wrong error received")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFirstlyDoublePromisesTupleFail() {
        testFirstlyNtuplePromisesFail { after, success, err in
            firstly { (err, success) }.then { (arg: (Any, Any)) -> AnyPromise in let (_, _) = arg; return () }
        }
    }

    func testFirstlyTriplePromisesTupleFail() {
        testFirstlyNtuplePromisesFail { after, success, err in
            firstly { (success, err, success) }.then { (arg: (Any, Any, Any)) -> AnyPromise in let (_, _, _) = arg; return () }
        }
    }

    func testFirstlyQuadruplePromisesTupleFail() {
        testFirstlyNtuplePromisesFail { after, success, err in
            firstly { (err, err, err, success) }.then { (arg: (Any, Any, Any, Any)) -> AnyPromise in let (_, _, _, _) = arg; return () }
        }
    }

    func testFirstlyQuintuplePromisesTupleFail() {
        testFirstlyNtuplePromisesFail { after, success, err in
            firstly { (success, success, err, err, success) }.then { (arg: (Any, Any, Any, Any, Any)) -> AnyPromise in let (_, _, _, _, _) = arg; return () }
        }
    }
}

fileprivate enum TestError: Error {
    case sthWrong
}

fileprivate func getPromises(callback: ((Promise<Bool>, Promise<Int>, Promise<String>, Promise<(Int, Int)>, Promise<Double>, Promise<Void>)) -> Void) {
    let boolean = after(interval: 0.1).then { true }
    let integer = Promise(value: 1)
    let string = Promise(value: "success")
    let integerTuple = after(interval: 0.1).then { (2, 3) }
    let double = Promise(value: 0.1)
    let empty = Promise(value: ())
    callback(boolean, integer, string, integerTuple, double, empty)
}
