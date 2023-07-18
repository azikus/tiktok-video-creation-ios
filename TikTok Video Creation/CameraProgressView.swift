//
//  CameraProgressView.swift
//  takko
//
//  Created by Azzaro Mujic on 31.05.2021..
//  Copyright © 2021 Content Creators, Inc. All rights reserved.
//

import UIKit
import SnapKit

protocol CameraProgressViewDelegate: AnyObject {
    func didFinish(in view: CameraProgressView)
}

class CameraProgressView: UIView {
    weak var delegate: CameraProgressViewDelegate?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.02)
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    lazy var animatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var addedViews: [UIView] = []
    
    var animator: UIViewPropertyAnimator?
    var historyFractionCompletion: [CGFloat] = []
    var pausedWithoutIndicator = false
    private var observeToken: NSKeyValueObservation?
    
    init() {
        super.init(frame: .zero)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(animatedView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        containerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(6)
        }
        animatedView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(containerView.snp.leading)
            make.width.equalToSuperview()
        }
    }
    
    func resume() {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: 29.5, curve: .linear, animations: {
                self.animatedView.transform = CGAffineTransform(translationX: self.containerView.frame.width, y: 0)
            })
            animator?.pausesOnCompletion = true
            observeToken?.invalidate()
            observeToken = animator?.observe(\.isRunning) {[weak self] animator, change in
                guard let self = self else { return }
                if !animator.isRunning && animator.fractionComplete == 1 {
                    self.delegate?.didFinish(in: self)
                }
            }
        }
        animator?.startAnimation()
        if !pausedWithoutIndicator {
            historyFractionCompletion.append(animator?.fractionComplete ?? 0)
        }
    }
    
    func pause(shouldAddIndicator: Bool) {
        guard let animator = animator else { return }
        animator.pauseAnimation()
        
        if shouldAddIndicator {        
            let view = UIView()
            view.backgroundColor = .white
            containerView.addSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalTo(2)
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(containerView.frame.width * animator.fractionComplete)
            }
            addedViews.append(view)
            pausedWithoutIndicator = false
        } else {
            pausedWithoutIndicator = true
        }
    }
    
    func reset() {
        historyFractionCompletion = []
        addedViews.forEach {
            $0.removeFromSuperview()
        }
        addedViews = []
        animator?.stopAnimation(true)
        self.animatedView.transform = .identity
        animator = nil        
    }
    
    func removeLast() {
        addedViews
            .removeLast()
            .removeFromSuperview()
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.animator?.fractionComplete = self.historyFractionCompletion.removeLast()
            self.animatedView.layoutIfNeeded()
        }
    }
    
    deinit {
        observeToken?.invalidate()
        animator?.stopAnimation(true)
    }
}
