//
//  pageResult.swift
//  Happie
//
//  Created by Chrissy Satyananda on 09/07/19.
//  Copyright © 2019 Odjichrissy. All rights reserved.
//

import UIKit
import Charts

class pageResult: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var mLType: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var recalculateButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scrollPageResult: UIScrollView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    let quotes = QuoteBanks()
    
    // data from previous segue
    var genderPassed: Double? = 0
    var agePassed : Double? = 0
    var jobPassed: Double? = 0
    var economicPassed: Double? = 0
    var livingPassed: Double? = 0
    var healthPassed: Double? = 0
    var mentalPassed: Double? = 0
    var socialPassed: Double? = 0
    
    // Machine learning model
    let model = logistic_model()
    let model2 = random_forest()
    
    // data for graph
    var totalData : Double = 129
    let happy10 : Double = 13
    let happy9 : Double = 29
    let happy8 : Double = 41
    let happy7 : Double = 24
    let happy7Kurang : Double = 22
    var jumlahAtas : Double = 0         // JumlahAtas = sum( happiness index > 7)
    var jumlahBawah : Double = 0        // JumlahBawah = sum( happiness index <= 7)
    
    let happinessStatus = ["Happy", "Less Happy"]
    var happinessValue : [Double] = []
    
    // data bar chart
    let age = ["19","20","21","22","22","23","23","24","24","25","25","26","26","27","27","28","28","29","29","30","30","31","31","32","32","33","33","34","34","35","35","36","36","37","39","40","41"]
    let happynessLevel : [Double] = [8,9,4,8,8,7,10,7,7,8,6,9,7,9,7,10,7,7,8,7,7,9,9,8,8,9,8,8,7,5,8,10,10,8,8,7,9]
    
    var persentaseAtas : Double = 0
    var persentaseBawah : Double = 0
    
    var prediction1a : Int64 = 0
    var prediction2a : Int64 = 0
    
    // Data for side scroller
    let WIDTH : CGFloat = 409
    let HEIGHT: CGFloat = 387
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchView.setOn(true, animated: true)
        mLType.text = "Logistic \nRegression"
        recalculateButton.layer.cornerRadius = 10
        topView.layer.cornerRadius = 40
        bottomView.layer.cornerRadius = 40
        
        let quoteRandom = Int.random(in: 1..<quotes.list.count)
        tipsLabel.text = quotes.list[quoteRandom].quoteText
        
        if (jobPassed! < 7.0) {
            tipsLabel.text = "You should enjoy your job more. \nDo what you love, love what you do"
        }else if (economicPassed! < 7.0){
            tipsLabel.text = "Gratitude opens the door to the power, \nthe wisdom, the creativity of the universe. \nYou open the door through gratitude"
        }else if (healthPassed! < 6){
            tipsLabel.text = "It is health that is real wealth and \nnot pieces of gold and silver"
        }else if (mentalPassed! > 4){
            tipsLabel.text = "Try changing those negative thoughts, it can improve your mood"
        }else{
            tipsLabel.text = quotes.list[quoteRandom].quoteText
        }
        
        if (switchView.isOn==true){
            self.scoreLabel.text = "Happines Index: \(prediction1a)"
        }else{
            self.scoreLabel.text = "Happines Index: \(prediction2a)"
        }
        
        if let predictions1 = try? model.prediction(Age: agePassed!, Job: jobPassed!, Economic: economicPassed!, Living: livingPassed!, Health: healthPassed!, Mental: mentalPassed!, Social: socialPassed!){

            let indexFormatter = NumberFormatter()
            indexFormatter.numberStyle = .decimal
            indexFormatter.maximumFractionDigits = 0
            self.scoreLabel.text = "Happines Index: " + indexFormatter.string(for: predictions1.Happiness)!
            prediction1a = predictions1.Happiness
        }
        else{
            print("Error")
        }
        
        jumlahAtas = happy10 + happy9 + happy8
        jumlahBawah = happy7 + happy7Kurang
        
        if prediction1a >= 7 {
            jumlahAtas += 1
            totalData += 1
            persentaseAtas = round(10*(jumlahAtas/totalData*100))/10
            persentaseBawah = round(10*(jumlahBawah/totalData*100))/10
            happinessValue.append(persentaseAtas)
            happinessValue.append(persentaseBawah)
            percentageLabel.text = "You are among \(persentaseAtas)% of the Happy Population"
        }else if prediction1a < 7{
            persentaseAtas = round(10*(jumlahAtas/totalData*100))/10
            persentaseBawah = round(10*(jumlahBawah/totalData*100))/10
            happinessValue.append(persentaseAtas)
            happinessValue.append(persentaseBawah)
            percentageLabel.text = "You are among \(persentaseBawah)% of the Less Happy Population"
        }
        
//      pieChartView.data =
        customizePieChart(dataPoints: happinessStatus, values: happinessValue.map{ Double($0) })
        customizeBarChart(dataPoints: age, values: happynessLevel.map{ Double($0) })
        

        for x in 1...2 {
            let img = UIImage(named: "\(x)")
            let imgView = UIImageView(image: img)

            scrollPageResult.addSubview(imgView)

            imgView.frame = CGRect(x: -WIDTH + (WIDTH*CGFloat(x)), y: 260, width: WIDTH, height: HEIGHT)
        }

        scrollPageResult.contentSize = CGSize (width: WIDTH * 3, height: scrollPageResult.frame.size.height)
        
        
    }

    func customizePieChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.maximumFractionDigits = 1
        format.multiplier = 1
        format.percentSymbol = " %"
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.0, easingOption: .easeInCirc)
    }
    
    func customizeBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]), data:age)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Age vs Happiness Level")
        chartDataSet.colors = colorsOfCharts(numbersOfColor: 3)
        
        let chartData = BarChartData(dataSet: chartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.maximumFractionDigits = 1
        format.multiplier = 1
        format.percentSymbol = " %"
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:age)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 5.5, yAxisDuration: 5.0, easingOption: .easeInBounce)
    }

    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    @IBAction func switchML(_ sender: UISwitch) {
        if (switchView.isOn==false) {
            mLType.text = "Random \nForest"
            if let predictions2 = try? model2.prediction(Age: agePassed!, Job: jobPassed!, Economic: economicPassed!, Living: livingPassed!, Health: healthPassed!, Mental: mentalPassed!, Social: socialPassed!){
                
                let indexFormatter = NumberFormatter()
                indexFormatter.numberStyle = .decimal
                indexFormatter.maximumFractionDigits = 0
                self.scoreLabel.text = "Happines Index: " + indexFormatter.string(for: predictions2.Happiness)!
                prediction2a = predictions2.Happiness
                
                if prediction2a >= 7{
//                    jumlahAtas += 1
//                    totalData += 1
                    persentaseAtas = round(10*(jumlahAtas/totalData*100))/10
                    persentaseBawah = round(10*(jumlahBawah/totalData*100))/10
                    happinessValue.append(persentaseAtas)
                    happinessValue.append(persentaseBawah)
                    percentageLabel.text = "You are among \(persentaseAtas)% of the Happy Population"
                }else if prediction2a < 7 {
                    persentaseAtas = round(10*(jumlahAtas/totalData*100))/10
                    persentaseBawah = round(10*(jumlahBawah/totalData*100))/10
                    happinessValue.append(persentaseAtas)
                    happinessValue.append(persentaseBawah)
                    percentageLabel.text = "You are among \(persentaseBawah)% of the Less Happy Population"
                }
            }
        }else{
            mLType.text = "Logistic \nRegression"
            if let predictions1 = try? model.prediction(Age: agePassed!, Job: jobPassed!, Economic: economicPassed!, Living: livingPassed!, Health: healthPassed!, Mental: mentalPassed!, Social: socialPassed!){
                
                let indexFormatter = NumberFormatter()
                indexFormatter.numberStyle = .decimal
                indexFormatter.maximumFractionDigits = 0
                self.scoreLabel.text = "Happines Index: " + indexFormatter.string(for: predictions1.Happiness)!
                prediction1a = predictions1.Happiness
                
                if prediction1a >= 7 {
//                    jumlahAtas += 1
//                    totalData += 1
                    persentaseAtas = round(10*(jumlahAtas/totalData*100))/10
                    persentaseBawah = round(10*(jumlahBawah/totalData*100))/10
                    happinessValue.append(persentaseAtas)
                    happinessValue.append(persentaseBawah)
                    percentageLabel.text = "You are among \(persentaseAtas)% of the Happy Population"
                }else if prediction1a < 7{
                    persentaseAtas = round(10*(jumlahAtas/totalData*100))/10
                    persentaseBawah = round(10*(jumlahBawah/totalData*100))/10
                    happinessValue.append(persentaseAtas)
                    happinessValue.append(persentaseBawah)
                    percentageLabel.text = "You are among \(persentaseBawah)% of the Less Happy Population"
                }
            }
            else{
                print("Error")
            }
        }
    }
    

}
