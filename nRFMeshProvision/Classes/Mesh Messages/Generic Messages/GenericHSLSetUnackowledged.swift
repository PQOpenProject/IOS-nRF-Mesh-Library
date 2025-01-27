/*
* Copyright (c) 2019, Nordic Semiconductor
* All rights reserved.

* Created by codepgq
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

import Foundation

public struct GenericHSLSetUnacknowledged: GenericMessage, TransactionMessage, TransitionMessage {
    public static var opCode: UInt32 = 0x8277
    public static var responseType: StaticMeshMessage.Type = GenericHSLStatus.self
    
    public var tid: UInt8!
    
    public var parameters: Data? {
        
        guard let (h,s,l,_) = color.hsl else { return Data() }
        let hValue = UInt16(h * 65535)
        let sValue = UInt16(s * 65535)
        let lValue = UInt16(l * 65535)
                
        let data = Data() + lValue + hValue + sValue + tid

        if let transitionTime = transitionTime, let delay = delay {
            return data + transitionTime.rawValue + delay
        } else {
            return data
        }
    }
    
    /// The target value of the Generic color state.
    public let color: UIColor
    
    public var transitionTime: TransitionTime?
    public var delay: UInt8?
    
    public init(color: UIColor) {
        self.color = color
        self.transitionTime = nil
        self.delay = nil
    }
    
    public init(color: UIColor, transitionTime: TransitionTime, delay: UInt8) {
        self.color = color
        self.transitionTime = transitionTime
        self.delay = delay
    }
    
    
    public init?(parameters: Data) {
        guard parameters.count == 7 || parameters.count == 9 else {
            return nil
        }
        let l = UInt16(parameters[0]) | (UInt16(parameters[1]) << 8)
        let h = UInt16(parameters[2]) | (UInt16(parameters[3]) << 8)
        let s = UInt16(parameters[4]) | (UInt16(parameters[5]) << 8)
        color = UIColor(hue: CGFloat(h) / 65535, saturation: CGFloat(s) / 65535, lightness: CGFloat(l) / 65535)
        tid = parameters[6]
        if parameters.count == 9 {
            transitionTime = TransitionTime(rawValue: parameters[7])
            delay = parameters[8]
        } else {
            transitionTime = nil
            delay = nil
        }
    }
    
}
