/*
* Copyright (c) 2019, Nordic Semiconductor
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification,
* are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice, this
*    list of conditions and the following disclaimer in the documentation and/or
*    other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors may
*    be used to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
* IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
* NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import XCTest
@testable import nRFMeshProvision

class AssigningUnicastAddress: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAssigningUnicastAddress_empty() {
        let meshNetwork = MeshNetwork(name: "Test network")
        
        let provisioner = Provisioner(name: "Test provisioner",
                                      allocatedUnicastRange: [ AddressRange(1...0x7FFF) ],
                                      allocatedGroupRange: [], allocatedSceneRange: [])
        
        let address = meshNetwork.nextAvailableUnicastAddress(for: 6, elementsUsing: provisioner)
        
        XCTAssertNotNil(address)
        XCTAssertEqual(address!, 1)
    }
    
    func testAssigningUnicastAddress_basic() {
        let meshNetwork = MeshNetwork(name: "Test network")
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 0", unicastAddress: 1, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 1", unicastAddress: 10, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 2", unicastAddress: 20, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 3", unicastAddress: 30, elements: 9)))
        
        let provisioner = Provisioner(name: "Test provisioner",
                                      allocatedUnicastRange: [
                                        AddressRange(100...200)
                                      ],
                                      allocatedGroupRange: [], allocatedSceneRange: [])
        
        let address = meshNetwork.nextAvailableUnicastAddress(for: 6, elementsUsing: provisioner)
        
        XCTAssertNotNil(address)
        XCTAssertEqual(address!, 100)
    }
    
    func testAssigningUnicastAddress_complex() {
        let meshNetwork = MeshNetwork(name: "Test network")
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 0", unicastAddress: 1, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 1", unicastAddress: 10, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 2", unicastAddress: 20, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 3", unicastAddress: 30, elements: 9)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 4", unicastAddress: 103, elements: 5)))
        
        let provisioner = Provisioner(name: "Test provisioner",
                                      allocatedUnicastRange: [
                                        AddressRange(100...200)
                                      ],
                                      allocatedGroupRange: [], allocatedSceneRange: [])
        
        let address = meshNetwork.nextAvailableUnicastAddress(for: 6, elementsUsing: provisioner)
        
        XCTAssertNotNil(address)
        XCTAssertEqual(address!, 108)
    }

    func testAssigningUnicastAddress_advanced() {
        let meshNetwork = MeshNetwork(name: "Test network")
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 0", unicastAddress: 1, elements: 10)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 1", unicastAddress: 12, elements: 18)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 2", unicastAddress: 30, elements: 11)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 3", unicastAddress: 55, elements: 10)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 4", unicastAddress: 65, elements: 5)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 5", unicastAddress: 73, elements: 5)))
        
        let provisioner = Provisioner(name: "Test provisioner",
                                      allocatedUnicastRange: [
                                        AddressRange(8...38),
                                        AddressRange(50...100),
                                        AddressRange(120...150)
                                      ],
                                      allocatedGroupRange: [], allocatedSceneRange: [])
        
        let address = meshNetwork.nextAvailableUnicastAddress(for: 6, elementsUsing: provisioner)
        
        XCTAssertNotNil(address)
        XCTAssertEqual(address!, 78)
    }
    
    func testAssigningUnicastAddress_none() {
        let meshNetwork = MeshNetwork(name: "Test network")
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 0", unicastAddress: 1, elements: 10)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 1", unicastAddress: 12, elements: 18)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 2", unicastAddress: 30, elements: 11)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 3", unicastAddress: 55, elements: 10)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 4", unicastAddress: 65, elements: 5)))
        XCTAssertNoThrow(try meshNetwork.add(node: Node(name: "Node 5", unicastAddress: 73, elements: 5)))
        
        let provisioner = Provisioner(name: "Test provisioner",
                                      allocatedUnicastRange: [
                                        AddressRange(8...38),
                                        AddressRange(50...80)
                                      ],
                                      allocatedGroupRange: [], allocatedSceneRange: [])
        
        let address = meshNetwork.nextAvailableUnicastAddress(for: 6, elementsUsing: provisioner)
        
        XCTAssertNil(address)
    }
    
    func testAssigningUnicastAdderessRanges() {
        let meshNetwork = MeshNetwork(name: "Test network")
        XCTAssertNoThrow(try meshNetwork.add(provisioner:
            Provisioner(name: "P0",
                        allocatedUnicastRange: [AddressRange(0x0001...0x00FF),
                                                AddressRange(0x0120...0x0FFF),
                                                AddressRange(0x2000...0x2FFF),
                                                AddressRange(0x6000...0x7FFF)],
                        allocatedGroupRange: [],
                        allocatedSceneRange: [])))
        
        let newRange0 = meshNetwork.nextAvailableUnicastAddressRange(ofSize: 1)
        XCTAssertNotNil(newRange0)
        XCTAssertEqual(newRange0?.lowerBound, 0x0100)
        XCTAssertEqual(newRange0?.upperBound, 0x0100)
        
        let newRange1 = meshNetwork.nextAvailableUnicastAddressRange(ofSize: 0x51)
        XCTAssertNotNil(newRange1)
        XCTAssertEqual(newRange1?.lowerBound, 0x1000)
        XCTAssertEqual(newRange1?.upperBound, 0x1050)
        
        let newRange2 = meshNetwork.nextAvailableUnicastAddressRange(ofSize: 0x1000)
        XCTAssertNotNil(newRange2)
        XCTAssertEqual(newRange2?.lowerBound, 0x1000)
        XCTAssertEqual(newRange2?.upperBound, 0x1FFF)
        
        let newRange3 = meshNetwork.nextAvailableUnicastAddressRange(ofSize: 0x2000)
        XCTAssertNotNil(newRange3)
        XCTAssertEqual(newRange3?.lowerBound, 0x3000)
        XCTAssertEqual(newRange3?.upperBound, 0x4FFF)
        
        let newRangeMax = meshNetwork.nextAvailableUnicastAddressRange()
        XCTAssertNotNil(newRangeMax)
        XCTAssertEqual(newRangeMax?.lowerBound, 0x3000)
        XCTAssertEqual(newRangeMax?.upperBound, 0x5FFF)
    }
    
    func testAssigningUnicastAdderessRanges_none() {
        let meshNetwork = MeshNetwork(name: "Test network")
        XCTAssertNoThrow(try meshNetwork.add(provisioner:
            Provisioner(name: "P0",
                        allocatedUnicastRange: [AddressRange(0x0001...0x7FFF)],
                        allocatedGroupRange: [],
                        allocatedSceneRange: [])))
        
        let newRange0 = meshNetwork.nextAvailableUnicastAddressRange(ofSize: 1)
        XCTAssertNil(newRange0)
    }
}
