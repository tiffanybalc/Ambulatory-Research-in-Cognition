/*
Copyright (c) 2017 Washington University in St. Louis 
Created by: Jason J. Hassenstab, PhD

Washington University in St. Louis hereby grants to you a non-transferable, non-exclusive, royalty-free license to use and copy the computer code provided here (the "Software").  You agree to include this license and the above copyright notice in all copies of the Software.  The Software may not be distributed, shared, or transferred to any third party.  This license does not grant any rights or licenses to any other patents, copyrights, or other forms of intellectual property owned or controlled by Washington University in St. Louis.

YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS PROVIDED "AS IS", WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WASHINGTON UNIVERSITY IN ST LOUIS BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE SOFTWARE, THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT OR OTHERWISE, EVEN IF SUCH PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 
*/

import Foundation

extension DateComponentsFormatter
{
    
    static func localizedString(forUnit unit:NSCalendar.Unit, style:DateComponentsFormatter.UnitsStyle) -> String
    {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [unit]
        formatter.unitsStyle = style
        formatter.maximumUnitCount = 1;
        if let str = formatter.string(from: 0)
        {
            let localizedStr = str.replacingOccurrences(of: "0", with: "").trimmingCharacters(in: .whitespaces);
            return localizedStr;
        }
        
        return "";
    }
    
}
