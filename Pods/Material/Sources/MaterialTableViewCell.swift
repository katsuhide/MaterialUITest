/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit

@IBDesignable
public class MaterialTableViewCell : UITableViewCell {
	/**
	A CAShapeLayer used to manage elements that would be affected by
	the clipToBounds property of the backing layer. For example, this
	allows the dropshadow effect on the backing layer, while clipping
	the image to a desired shape within the visualLayer.
	*/
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	A base delegate reference used when subclassing MaterialView.
	*/
	public weak var delegate: MaterialDelegate?
	
	/// To use a single pulse and have it focused when held.
	@IBInspectable public var pulseFocus: Bool = false
	
	/// A pulse layer for focus handling.
	public private(set) var pulseLayer: CAShapeLayer?
	
	/// Sets whether the scaling animation should be used.
	@IBInspectable public lazy var pulseScale: Bool = true
	
	/// The opcaity value for the pulse animation.
	@IBInspectable public var pulseOpacity: CGFloat = 0.25
	
	/// The color of the pulse effect.
	@IBInspectable public var pulseColor: UIColor?
	
	/**
	This property is the same as clipsToBounds. It crops any of the view's
	contents from bleeding past the view's frame. If an image is set using
	the image property, then this value does not need to be set, since the
	visualLayer's maskToBounds is set to true by default.
	*/
	@IBInspectable public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/**
	A property that accesses the layer.frame.origin.width property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the height will be adjusted to maintain the correct
	shape.
	*/
	@IBInspectable public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/**
	A property that accesses the layer.frame.origin.height property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the width will be adjusted to maintain the correct
	shape.
	*/
	@IBInspectable public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A property that accesses the backing layer's shadowColor.
	@IBInspectable public var shadowColor: UIColor? {
		didSet {
			layer.shadowColor = shadowColor?.CGColor
		}
	}
	
	/// A property that accesses the backing layer's shadowOffset.
	@IBInspectable public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set(value) {
			layer.shadowOffset = value
		}
	}
	
	/// A property that accesses the backing layer's shadowOpacity.
	@IBInspectable public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set(value) {
			layer.shadowOpacity = value
		}
	}
	
	/// A property that accesses the backing layer's shadowRadius.
	@IBInspectable public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set(value) {
			layer.shadowRadius = value
		}
	}
	
	/// A property that accesses the backing layer's shadowPath.
	@IBInspectable public var shadowPath: CGPath? {
		get {
			return layer.shadowPath
		}
		set(value) {
			layer.shadowPath = value
		}
	}
	
	/// Enables automatic shadowPath sizing.
	@IBInspectable public var shadowPathAutoSizeEnabled: Bool = true {
		didSet {
			if shadowPathAutoSizeEnabled {
				layoutShadowPath()
			} else {
				shadowPath = nil
			}
		}
	}
	
	/**
	A property that sets the shadowOffset, shadowOpacity, and shadowRadius
	for the backing layer. This is the preferred method of setting depth
	in order to maintain consitency across UI objects.
	*/
	public var depth: MaterialDepth = .None {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(depth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
			layoutShadowPath()
		}
	}
	
	/**
	A property that sets the cornerRadius of the backing layer. If the shape
	property has a value of .Circle when the cornerRadius is set, it will
	become .None, as it no longer maintains its circle shape.
	*/
	public var cornerRadiusPreset: MaterialRadius = .None {
		didSet {
			if let v: MaterialRadius = cornerRadiusPreset {
				cornerRadius = MaterialRadiusToValue(v)
			}
		}
	}
	
	/// A property that accesses the layer.cornerRadius.
	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set(value) {
			layer.cornerRadius = value
			layoutShadowPath()
		}
	}
	
	/// A preset property to set the borderWidth.
	public var borderWidthPreset: MaterialBorder = .None {
		didSet {
			borderWidth = MaterialBorderToValue(borderWidthPreset)
		}
	}
	
	/// A property that accesses the layer.borderWith.
	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set(value) {
			layer.borderWidth = value
		}
	}
	
	/// A property that accesses the layer.borderColor property.
	@IBInspectable public var borderColor: UIColor? {
		get {
			return nil == layer.borderColor ? nil : UIColor(CGColor: layer.borderColor!)
		}
		set(value) {
			layer.borderColor = value?.CGColor
		}
	}
	
	/// A property that accesses the layer.position property.
	@IBInspectable public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/// A property that accesses the layer.zPosition property.
	@IBInspectable public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	An initializer that initializes the object.
	- Parameter style: A UITableViewCellStyle enum.
	- Parameter reuseIdentifier: A String identifier.
	*/
	public override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		prepareView()
	}
	
	/// Overriding the layout callback for sublayers.
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			layoutVisualLayer()
			layoutShadowPath()
		}
	}
	
	/**
	A method that accepts CAAnimation objects and executes them on the
	view's backing layer.
	- Parameter animation: A CAAnimation instance.
	*/
	public func animate(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			layer.addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
	A delegation method that is executed when the backing layer starts
	running an animation.
	- Parameter anim: The currently running CAAnimation instance.
	*/
	public override func animationDidStart(anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	A delegation method that is executed when the backing layer stops
	running an animation.
	- Parameter anim: The CAAnimation instance that stopped running.
	- Parameter flag: A boolean that indicates if the animation stopped
	because it was completed or interrupted. True if completed, false
	if interrupted.
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				if let v: AnyObject = b.toValue {
					if let k: String = b.keyPath {
						layer.setValue(v, forKeyPath: k)
						layer.removeAnimationForKey(k)
					}
				}
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	/**
	Triggers the pulse animation.
	- Parameter point: A Optional point to pulse from, otherwise pulses
	from the center.
	*/
	public func pulse(point: CGPoint? = nil) {
		let p: CGPoint = nil == point ? CGPointMake(CGFloat(width / 2), CGFloat(height / 2)) : point!
		let duration: NSTimeInterval = MaterialAnimation.pulseDuration(width)
		
		if let v: UIColor = pulseColor {
			MaterialAnimation.pulseAnimation(layer, visualLayer: visualLayer, color: v.colorWithAlphaComponent(pulseOpacity), point: p, width: width, height: height, duration: duration)
		}
		
		if pulseScale {
			MaterialAnimation.expandAnimation(layer, scale: 1.05, duration: duration)
			MaterialAnimation.delay(duration) { [weak self] in
				if let l: CALayer = self?.layer {
					if let w: CGFloat = self?.width {
						MaterialAnimation.shrinkAnimation(l, width: w, duration: duration)
					}
				}
			}
		}
	}
	
	/**
	A delegation method that is executed when the view has began a
	touch event.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let duration: NSTimeInterval = MaterialAnimation.pulseDuration(width)
		
		if pulseFocus {
			pulseLayer = CAShapeLayer()
		}
		
		if let v: UIColor = pulseColor {
			MaterialAnimation.pulseAnimation(layer, visualLayer: visualLayer, color: v.colorWithAlphaComponent(pulseOpacity), point: layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer), width: width, height: height, duration: duration, pulseLayer: pulseLayer)
		}
		
		if pulseScale {
			MaterialAnimation.expandAnimation(layer, scale: 1.05, duration: duration)
		}
	}
	
	/**
	A delegation method that is executed when the view touch event has
	ended.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		MaterialAnimation.shrinkAnimation(layer, width: width, duration: MaterialAnimation.pulseDuration(width), pulseLayer: pulseLayer)
	}
	
	/**
	A delegation method that is executed when the view touch event has
	been cancelled.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		MaterialAnimation.shrinkAnimation(layer, width: width, duration: MaterialAnimation.pulseDuration(width), pulseLayer: pulseLayer)
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		prepareVisualLayer()
		selectionStyle = .None
		pulseColor = MaterialColor.grey.lighten1
		pulseScale = false
		imageView?.userInteractionEnabled = false
		textLabel?.userInteractionEnabled = false
		detailTextLabel?.userInteractionEnabled = false
	}
	
	/// Prepares the visualLayer property.
	internal func prepareVisualLayer() {
		visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		contentView.layer.addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.cornerRadius = cornerRadius
	}
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if shadowPathAutoSizeEnabled {
			if .None == depth {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath
			} else {
				animate(MaterialAnimation.shadowPath(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath, duration: 0))
			}
		}
	}
}
