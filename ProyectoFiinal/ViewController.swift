//
//  ViewController.swift
//  ProyectoFiinal
//
//  Created by user130165 on 12/8/17.
//  Copyright © 2017 KevinGonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myLabels : [UILabel] = []
    @IBOutlet weak var HorzStack: UIStackView!
    @IBAction func btnRestart(_ sender: UIButton)
    {
        for i in 0 ..< myLabels.count
        {
            myLabels[i].isHidden = true
        }
        for j in 0 ..< Botones.count
        {
            for k in 0 ..< Botones[j].count
            {
                Botones[j][k].backgroundColor = UIColor.cyan
                Botones[j][k].isEnabled = true
            }
        }
        construccion = ""
        posiciones.removeAll()
    }
    @IBOutlet weak var lblStackView: UIStackView!
    @IBAction func btnOk(_ sender: UIButton)
    {
        for j in 0 ..< Botones.count
        {
            for k in 0 ..< Botones[j].count
            {
                if (Botones[j][k].backgroundColor == UIColor.yellow)
                {
                    construccion = construccion + Botones[j][k].titleLabel!.text!
                    let Ycord : Int = Botones[j][k].tag / 100
                    let Xcord : Int = Botones[j][k].tag - 100*Ycord
                    let Pos = [Xcord, Ycord]
                    posiciones.append(Pos)
                }
            }
        }
        let reversed = String(Array(construccion.characters).reversed())
        if (cities.contains(reversed))
        {
            construccion = reversed
        }
        
        if (cities.contains(construccion) && checkPosiciones())
        {
            //palabra encontrada
            for i in 0 ..< myLabels.count
            {
                if myLabels[i].text! == construccion
                {
                    myLabels[i].isHidden = false
                }
            }
            
            for j in 0 ..< Botones.count
            {
                for k in 0 ..< Botones[j].count
                {
                    if (Botones[j][k].backgroundColor == UIColor.yellow)
                    {
                        Botones[j][k].backgroundColor = UIColor.green
                    }
                }
            }
        }
        else{
            for j in 0 ..< Botones.count
            {
                for k in 0 ..< Botones[j].count
                {
                    if (Botones[j][k].backgroundColor == UIColor.yellow)
                    {
                        Botones[j][k].backgroundColor = UIColor.cyan
                        Botones[j][k].isEnabled = true
                    }
                }
            }
            
        }
        construccion = ""
        posiciones.removeAll()
    }
    
    
    var orientacion : [String : Int] = ["Horiz":0,"Vert":0,"VerInv":0,"DiagDesc":0,"DiagAsc":0]
    
    var dimension = 0
    var cities : [String] = []
    var charCities : [[Character]] = []
    var Botones : [[UIButton]] = []
    var construccion = ""
    var posiciones : [[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFile(filename: "ciudades")
        fillLabels()
        for i in 0 ..< cities.count
        {
            myLabels[i].text! = cities[i]
            myLabels[i].isHidden = true
        }
        findDimension()
        for _ in 0..<dimension
        {
            var myArray : [Character] = []
            for _ in 0 ..< dimension
            {
                myArray.append(" ")
            }
            sopa.append(myArray)
        }
        
        for i in 0 ..< cities.count
        {
            switch getOrien() {
            case "Horiz":
                placeWordHoriz(position: i)
            case "Vert":
                placeWordVert(position: i)
            case "VertInv":
                placeWordVertInv(position: i)
            case "DiagDesc":
                placeWordDiagDesc(position: i)
            case "DiagAsc":
                placeWordDiagAsc(position: i)
            default:
                print("Error")
            }
        }
        HorzStack.distribution = .fillEqually
        HorzStack.axis = .vertical
        fillSopa()
        CrearBotones()
        
    }
    var calls = 0;
    
    func fillLabels()
    {
        lblStackView.axis = .vertical
        lblStackView.distribution = .fillEqually
        lblStackView.spacing = CGFloat(10)
        for ciudad in cities
        {
            let label = UILabel()
            label.text = ciudad
            label.textColor = UIColor.black
            myLabels.append(label)
            lblStackView.addArrangedSubview(label)
        }
    }
    
    func wordFitsHor(size : Int, x: Int, y : Int) -> Bool
    {
        let maxHor = dimension - x
        if (maxHor < size)
        {
            return false
        }
        for i in 0 ..< size
        {
            if !(sopa[y][x+i] == " ")
            {
                return false
            }
        }
        
        return true;
    }
    func wordFitsVer(size : Int, x: Int, y : Int) -> Bool
    {
        let maxVer = dimension - y
        if (maxVer < size)
        {
            return false
        }
        for i in 0 ..< size
        {
            if !(sopa[y+i][x] == " ")
            {
                return false
            }
        }
        
        return true;
    }
    
    func wordFitsDiag(size : Int, x: Int, y : Int) -> Bool
    {
        let maxVer = dimension - y
        let maxHor = dimension - x
        if (maxVer < size || maxHor<size)
        {
            return false
        }
        for i in 0 ..< size
        {
            if !(sopa[y+i][x+i] == " ")
            {
                return false
            }
        }
        
        return true;
    }
    func wordFitsDiag2(size: Int, x: Int, y: Int) -> Bool
    {
        let maxVer = y
        let maxHor = dimension - x
        if (maxVer < size || maxHor<size)
        {
            return false
        }
        for i in 0 ..< size
        {
            if !(sopa[y-i][x+i] == " ")
            {
                return false
            }
        }
        return true;
    }
    func placeWordHoriz( position:Int)
    {
        let word = charCities[position]
        var xCord = 0
        var yCord = 0
        while true {
            xCord = Int(arc4random_uniform(UInt32(dimension)))
            yCord = Int(arc4random_uniform(UInt32(dimension)))
            if wordFitsHor(size: word.count, x: xCord, y: yCord)
            {
                break
            }
        }
        for i in 0 ..< word.count
        {
            sopa[yCord][xCord+i] = word[i]
        }
        
    }
    
    func  placeWordVert (position : Int)
    {
        let word = charCities[position]
        var xCord = 0
        var yCord = 0
        while true {
            xCord = Int(arc4random_uniform(UInt32(dimension)))
            yCord = Int(arc4random_uniform(UInt32(dimension)))
            if wordFitsVer(size: word.count, x: xCord, y: yCord)
            {
                break
            }
        }
        for i in 0 ..< word.count
        {
            sopa[yCord+i][xCord] = word[i]
        }
        
    }
    func  placeWordVertInv (position : Int)
    {
        let word = charCities[position]
        var xCord = 0
        var yCord = 0
        while true {
            xCord = Int(arc4random_uniform(UInt32(dimension)))
            yCord = Int(arc4random_uniform(UInt32(dimension)))
            if wordFitsVer(size: word.count, x: xCord, y: yCord)
            {
                break
            }
        }
        for i in 0 ..< word.count
        {
            sopa[yCord+i][xCord] = word[word.count - i - 1]
        }
    }
    func  placeWordDiagAsc (position : Int)
    {
        let word = charCities[position]
        var xCord = 0
        var yCord = 0
        while true {
            xCord = Int(arc4random_uniform(UInt32(dimension)))
            yCord = Int(arc4random_uniform(UInt32(dimension)))
            if wordFitsDiag2(size: word.count, x: xCord, y: yCord)
            {
                break
            }
        }
        for i in 0 ..< word.count
        {
            sopa[yCord-i][xCord+i] = word[i]
        }
    }
    func  placeWordDiagDesc (position : Int)
    {
        let word = charCities[position]
        var xCord = 0
        var yCord = 0
        while true {
            xCord = Int(arc4random_uniform(UInt32(dimension)))
            yCord = Int(arc4random_uniform(UInt32(dimension)))
            if wordFitsDiag(size: word.count, x: xCord, y: yCord)
            {
                break
            }
        }
        for i in 0 ..< word.count
        {
            sopa[yCord+i][xCord+i] = word[i]
        }
    }
    
    
    var sopa = [[Character]]()
    var contador = 0
    
    func getOrien() -> String
    {
        while true {
            var rand = arc4random_uniform(5)
            if contador >= 10
            {
                rand = 10
            }
            switch rand {
            case 0:
                if orientacion ["Horiz"]! < 2
                {
                    orientacion ["Horiz"] = orientacion ["Horiz"]! + 1
                    contador += 1
                    return "Horiz"
                }
                else
                {
                    continue
                }
            case 1:
                if orientacion ["Vert"]! < 2
                {
                    orientacion ["Vert"] = orientacion ["Vert"]! + 1
                    contador += 1
                    return "Vert"
                }
                else
                {
                    continue
                }
            case 2:
                if orientacion ["VerInv"]! < 2
                {
                    orientacion ["VerInv"] = orientacion ["VerInv"]! + 1
                    contador += 1
                    return "VertInv"
                }
                else
                {
                    continue
                }
            case 3:
                if orientacion ["DiagDesc"]! < 2
                {
                    contador += 1
                    orientacion ["DiagDesc"] = orientacion ["DiagDesc"]! + 1
                    return "DiagDesc"
                }
                else
                {
                    continue
                }
            case 4:
                if orientacion ["DiagAsc"]! < 2
                {
                    contador += 1
                    orientacion ["DiagAsc"] = orientacion ["DiagAsc"]! + 1
                    return "DiagAsc"
                }
                else
                {
                    continue
                }
            default:
                return direcciones[Int(arc4random_uniform(5))]
            }
        }
    }
    
    let direcciones  = ["Horiz","Vert","VertInv","DiagDesc","DiagAsc"]
    
    
    //encuentra cual es la palabra mas larga
    func findDimension()
    {
        var maxVal = 0
        for myArray : [Character] in charCities
        {
            if maxVal < myArray.count
            {
                maxVal = myArray.count
                dimension = maxVal * 2 + (cities.count / 3)
            }
        }
    }
    
    func readFile (filename : String)
    {
        let path = Bundle.main.path(forResource: filename, ofType: "txt")
        let fileMngr = FileManager.default
        if fileMngr.fileExists(atPath: path!)
        {
            do{
                let fulltxt = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                cities  = fulltxt.components(separatedBy: "\n") as [String]
                while cities.contains("") {
                    cities.remove(at: cities.index(of: "")!)
                }
                
                
                for i in 0 ..< cities.count
                {
                    cities[i] = cities[i].replacingOccurrences(of: "\r", with: "")
                    let myArray = Array(cities[i].characters)
                   charCities.append(myArray)
                }
            }
            catch let error as NSError{
                print(error)
            }
        }
    }
    
    func fillSopa()
    {
        let alfabeto = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let abecedario = Array(alfabeto.characters)
        for i in 0 ..< sopa.count
        {
            for j in 0 ..< sopa[i].count
            {
                if (sopa[i][j] == " ")
                {
                    sopa[i][j] = abecedario[Int(arc4random_uniform(UInt32(abecedario.count)))]
                }
            }
        }
    }
    
    func CrearBotones()
    {
        
        for i in 0 ..< dimension
        {
            let stackView  = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            var arrButtons : [UIButton] = []
            var contador = 0
            for char in sopa[i]
            {
                let boton = UIButton()
                boton.setTitleColor(UIColor.black, for: .normal)
                boton.backgroundColor = UIColor.cyan
                boton.setTitle(String(char), for: UIControlState.normal)
                boton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
                boton.tag = i*100 + contador
                contador += 1
                arrButtons.append(boton)
                stackView.addArrangedSubview(boton)
            }
            Botones.append(arrButtons)
            HorzStack.addArrangedSubview(stackView)
        }
    }
    
    func onClick (sender : UIButton)
    {
        sender.backgroundColor = UIColor.yellow
        sender.isEnabled = false

    }
    
    func checkPosiciones() -> Bool
    {
        var PosX : [Int] = []
        var PosY : [Int] = []
        for pos in posiciones
        {
            PosX.append(pos[0])
            PosY.append(pos[1])
        }
       
        var horizontal = true
        var vertical = true
        
        for i in 0 ..< PosY.count
        {
            if (PosX[0] != PosX[i])
            {
                vertical = false
            }
            if (PosY[0] != PosY[i])
            {
                horizontal = false
            }
        }
        
        if (vertical || horizontal)
        {
            var copyPosX = PosX
            copyPosX.sort()
            var copyPosY = PosY
            copyPosY.sort()
            for i in 1 ..< PosY.count
            {
                let dif = abs(copyPosY[0]-copyPosY[i])
                if dif != i
                {
                    vertical = false
                }
                let dif2 = abs(copyPosX[0] - copyPosX[i] )
                if dif2 != i
                {
                    horizontal = false
                }
            }
        }
        
        if vertical
        {
            return true;
        }
        
        if horizontal
        {
            return true;
        }
        
        var diagonal = true;
        //si no es vertical ni horizontal puede ser diagonal
        if(!horizontal && !vertical)
        {
            //dos puntos generan una linea
            for h in 0 ..< PosY.count
            {
                let myDifVer = abs(PosY[0] - PosY[h])
                let myDifHor = abs(PosX[0] - PosX[h])
                if ((myDifVer != myDifHor) || (myDifHor != h))
                {
                    diagonal = false
                }
            }
        }
        
        if(diagonal)
        {
            return true
        }
        
        return false
    }
    

}


