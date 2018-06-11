/*
Copyright (c) 2017 Washington University in St. Louis 
Created by: Jason J. Hassenstab, PhD

Washington University in St. Louis hereby grants to you a non-transferable, non-exclusive, royalty-free license to use and copy the computer code provided here (the "Software").  You agree to include this license and the above copyright notice in all copies of the Software.  The Software may not be distributed, shared, or transferred to any third party.  This license does not grant any rights or licenses to any other patents, copyrights, or other forms of intellectual property owned or controlled by Washington University in St. Louis.

YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS PROVIDED "AS IS", WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WASHINGTON UNIVERSITY IN ST LOUIS BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE SOFTWARE, THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT OR OTHERWISE, EVEN IF SUCH PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 
*/

import UIKit

class DNPricesTestViewController: DNTestViewController, DNPriceQuestionDelegate {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var goodPriceLabel: UILabel!
    
    @IBOutlet weak var yesButton: ToggleButton!
    @IBOutlet weak var noButton: ToggleButton!

    private var questionDisplay:DNPricesQuestionViewController?
    private var test:DNPricesTest?
    private var itemIndex = 0
    private var questionIndex = 0
    private var flippedPrices:Set<Int>! = nil
    var displayTimer:Timer?;
    
    
    override func getTest<T : DNTest>() -> T? {
        //If our test matches what the outside context wants, pass it back
        return self.test as? T
    }

    override func setTest<T : DNTest>(test: T) {
        self.test = test as? DNPricesTest

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.shouldAutoToggle = false;
        noButton.shouldAutoToggle = false;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isBeingPresented {
            self.test?.startTest()
            displayItem()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextItem()
    {
        itemIndex += 1;
        displayItem();
    }
    
    func displayItem() {
        
        displayTimer?.invalidate();
        
        yesButton.isSelected = false;
        yesButton.isUserInteractionEnabled = true;
        noButton.isSelected = false;
        noButton.isUserInteractionEnabled = true;
        
        if flippedPrices == nil {
            flippedPrices = uniqueSet(count: test!.itemCount/2, maxValue: test!.itemCount)

        }
        if itemIndex < test!.itemCount {
            guard var item = test?.testData.items[itemIndex] else {
                return
            }
            let topLabel = (flippedPrices.contains(itemIndex)) ? itemNameLabel : itemPriceLabel
            let bottomLabel = (topLabel == itemNameLabel) ? itemPriceLabel : itemNameLabel
            topLabel?.text = item.name
            bottomLabel?.text = item.prices[item.correct]
            
            bottomLabel?.resizeFontForSingleWords();
            topLabel?.resizeFontForSingleWords();
            
            test?.testData.items[itemIndex].inputData.stimulusDisplayTime = Date();
            
        displayTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextItem), userInfo: nil, repeats: false)
        } else {

            guard let vc:TextAlertViewController = DNAlertViewController.GetAlertController() else {
                return
            }
            vc.setText(string: "You will now start the test.\nYou will see an item and two prices. Please select the price that matches the item you studied.".localized(key: "price_popup"))
            
            vc.timein = 3.0;
            vc.timeout = 15;
            
            self.yesButton.isHidden = true;
            self.noButton.isHidden = true;
            self.goodPriceLabel.isHidden = true;
            self.itemNameLabel.text = ""
            self.itemPriceLabel.text = ""
            
            

            vc.onConfirm = {[weak self] ret in
                if let weakSelf = self {
                    weakSelf.test!.testData.items.shuffle()

                    //Present controller
                    weakSelf.questionDisplay = UIStoryboard(name: "PricesTest", bundle: nil).instantiateViewController(withIdentifier: "questionPanel") as? DNPricesQuestionViewController
                    weakSelf.questionDisplay?.delegate = weakSelf
                    weakSelf.present(weakSelf.questionDisplay!, animated: false, completion: { [weak self] in
                        guard let weakself = self else {
                            return
                        }
                        weakself.questionDisplay?.presentQuestion(item: (weakself.test?.testData.items[weakself.questionIndex])!, variation: (weakSelf.test is DNPricesTestVariationA) ? 1 : 0)
                    })
                }
            }
            
            self.present(vc, animated: false, completion: nil);
            
            //Suffle before input

        }

    }
    
    
    @IBAction func yesPressed(_ sender:UIButton)
    {
        yesButton.isSelected = true;
        noButton.isSelected = false;
        test?.testData.items[itemIndex].goodPrice = 1;
    }
    
    @IBAction func noPressed(_ sender:UIButton)
    {
        yesButton.isSelected = false;
        noButton.isSelected = true;
        test?.testData.items[itemIndex].goodPrice = 0;
    }

   //MARK: - DNPriceQuestionDelegate

    func didAnswerWithValue(data: DNPriceInputData) {
        
        test?.testData.items[questionIndex].inputData = data;
        questionIndex += 1
        
        if questionIndex < test!.itemCount {
            questionDisplay?.presentQuestion(item: (test?.testData.items[questionIndex])!,variation: (self.test is DNPricesTestVariationA) ? 1 : 0)
        } else {
            self.questionDisplay?.dismiss(animated: false, completion: nil)

            test?.endTest()

            endTest()
            self.itemNameLabel.text = ""
            self.itemPriceLabel.text = ""

        }

    }

}


