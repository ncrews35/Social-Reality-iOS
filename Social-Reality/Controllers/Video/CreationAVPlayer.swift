//
//  CreationAVPlayer.swift
//  Social-Reality
//
//  Created by Nick Crews on 3/18/21.
//

import UIKit
import AVKit

class CreationAVPlayerView: UIView {
    
    @IBOutlet weak var centerIndicator: UIImageView!
    @IBOutlet weak var volumeIndicatorButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var urlString: String?
    private var player: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer?
    
    var playing = false
    private var muted = false
    
    weak var delegate: CreationAVPlayerDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    
    func setupVideo(url: String?) {

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        } catch {
            print("no audio ")
        }
        
        volumeIndicatorButton.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        
        centerIndicator.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        
        tap.require(toFail: doubleTap)
        tap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        addGestureRecognizer(tap)
        addGestureRecognizer(doubleTap)
        
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        urlString = url
        
        guard let url = URL(string: url ?? "") else { return }
        
        print("got asset", url.absoluteString)
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVQueuePlayer(playerItem: playerItem)
        
        guard let player = player else { return }
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
   
        guard let playerLayer = playerLayer else { return }
        
        layer.addSublayer(playerLayer)
        
        loadingIndicator.alpha = 1
        loadingIndicator.startAnimating()
        
        bringSubviewToFront(centerIndicator)
        bringSubviewToFront(volumeIndicatorButton)
//        bringSubviewToFront(loadingIndicator)
        
    }
    
    @objc func tapped() {
        
        if playing {
            pauseCreation(); animateCenter(image: "pause.fill")
        } else {
            playCreation(); animateCenter(image: "play.fill")
        }
            
    }
    
    @objc func doubleTapped() {
        Buzz.light()
        
        delegate?.doubleTappedVideo()
        animateCenter(image: "heart.fill")
    }
    
    func animateCenter(image: String) {
        centerIndicator.image = UIImage(systemName: image)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.centerIndicator.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.centerIndicator.alpha = 0
            } completion: { _ in }
        }

    }
    
   
    func playCreation() {
//        loadingIndicator.alpha = 0
//        loadingIndicator.stopAnimating()
        player?.play()
        playing = true
        print("playing")
    }
    
    func restartCreation() {
//        loadingIndicator.alpha = 0
//        loadingIndicator.stopAnimating()
        player?.seek(to: .zero) { [weak self] _ in
            self?.player?.pause()
            self?.player?.rate = 1
        }
        playing = false
        
        print("restarted")
    }
    
    
    func pauseCreation() {
        player?.pause()
        playing = false
        print("pausing")
    }
    
    @IBAction func tapVolume(_ sender: UIButton) {
        
        sender.jump()
        
        guard let player = player else { return }
        
        player.isMuted = !player.isMuted
        
        player.isMuted ?
            volumeIndicatorButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal) :
            volumeIndicatorButton.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        
        
    }
    
}

protocol CreationAVPlayerDelegate: AnyObject {
    func doubleTappedVideo()
}
