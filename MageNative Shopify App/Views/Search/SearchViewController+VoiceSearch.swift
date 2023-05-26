//
//  SearchViewController+VoiceSearch.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import Speech

extension NewSearchVC: SFSpeechRecognizerDelegate {
    
    // MARK: Voice search
    
  //  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
  @objc  func searchBarVoiceBtnTapped(_ sender: UIButton){
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        } else {
            showSpeechPopup()
            startRecording()
        }
        
    }
    
    func requestAuth() {
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
            case .notDetermined:
                isButtonEnabled = false
            case .restricted:
                isButtonEnabled = false
            }
            
            OperationQueue.main.addOperation {
                self.searchBar.showsSearchResultsButton = isButtonEnabled
            }
            
        }
        
    }
    
    
    func startRecording() {
        
        if recognitionTask != nil {
            
            recognitionTask?.cancel()
            recognitionTask = nil
            
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        //recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecongniser?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            
            if result != nil {
                self.updateUIWithTranscription(result!.bestTranscription)
                //self.inputTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            print("finalres\(isFinal)")
            if let timer = self.detectionTimer, timer.isValid {
                if isFinal {
                    self.updateUIWithTranscription(result!.bestTranscription)
                    self.detectionTimer?.invalidate()
                    //self.searchBarcode(text: self.voiceSearchView.heading2.text!)
                }
            } else {
                self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                    //self.handleSend()
                    print("handle listing \(self.voiceSearchView.heading2.text!)")
                    if #available(iOS 13.0, *) {
                        //self.searchBar.searchTextField.text = self.voiceSearchView.heading2.text!
                           }
                    self.searchBar.text = self.voiceSearchView.heading2.text!
                    //self.searchBarcode(text: self.voiceSearchView.heading2.text!)
                    if self.audioEngine.isRunning {
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
                        self.audioEngine.inputNode.removeTap(onBus: 0)
                        self.searchBarcode(text: self.voiceSearchView.heading2.text!)
                    }
                    
                    self.view.viewWithTag(332211)?.removeFromSuperview()
                    self.view.viewWithTag(112233)?.removeFromSuperview()
                    
                   // self.loadProducts(searchText:self.voiceSearchView.heading2.text!)
                    
                    
                    //self.moveToProductListing(With: self.voiceSearchView.heading2.text! )
                    isFinal = true
                    timer.invalidate()
                })
            }
            
            
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //speakTextLbl.text = "Say something, I'm listening!"
        
    }
    
    fileprivate func updateUIWithTranscription(_ transcription: SFTranscription) {
        DispatchQueue.main.async {
            self.voiceSearchView.heading2.text = transcription.formattedString
        }
        
        
    }
    
    
    func showSpeechPopup() {
        
        let upView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        upView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        upView.tag = 332211
        view.addSubview(upView)
        voiceSearchView = VoiceSearchView()
        upView.addSubview(voiceSearchView)
       // voiceSearchView.micBtn.addTarget(self, action: #selector(voiceSearchTapped(_:)), for: .touchUpInside)
        voiceSearchView.cancelBtn.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
        voiceSearchView.tag = 112233
        voiceSearchView.anchor(width: upView.frame.width - 80,height: 230)
        voiceSearchView.center(inView: self.view)
        voiceSearchView.clipsToBounds = true
        voiceSearchView.layer.cornerRadius = 12.0
        
    }
    
    @objc func voiceSearchTapped(_ sender: UIButton) {
        startRecording()
    }

    @objc func cancelTapped(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        self.view.viewWithTag(332211)?.removeFromSuperview()
        self.view.viewWithTag(112233)?.removeFromSuperview()
    }
    
    
//    func moveToProductListing(With text: String) {
//
//        if audioEngine.isRunning {
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//            audioEngine.inputNode.removeTap(onBus: 0)
//        }
//
//        self.view.viewWithTag(332211)?.removeFromSuperview()
//        self.view.viewWithTag(112233)?.removeFromSuperview()
//
//        let vc = UIStoryboard(name: "categorylayouts", bundle: nil).instantiateViewController(withIdentifier: "cedMageDefaultCollection") as!  cedMageDefaultCollection
//        vc.searchString = text
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    
    
    
}
