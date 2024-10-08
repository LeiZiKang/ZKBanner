// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import SnapKit
import SDWebImage

public typealias BannerResult = (Int) -> Void

public class ZKBanner: UIView{
    
    var pageCon: UIPageViewController
    
    /// 页面指示器
    public var indicator: UIPageControl
    
    var dataSource: Int
    
    var imageArr: Array<String>
    
    var controlls: [UIViewController]
    
    var tagIndex: Int
    
    var timer: Timer?
    
    var block: BannerResult?
    
    var isAuto: Bool
    
    /// 循环时间
    public var loop: Double
    
    public override init(frame: CGRect) {
        controlls = []
        
        tagIndex = 0
        
        pageCon = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
       
        indicator = UIPageControl.init()
        imageArr = []
        dataSource = 0
        isAuto = false
        loop = 5
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initView() {
        
        pageCon.delegate = self
        pageCon.dataSource = self
        pageCon.view.frame = self.bounds
        self.addSubview(pageCon.view)
        
        self.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(10)
        }
        
    }
    
    ///  轮播图片
    public func initImages(with arr: Array<String>, block: @escaping BannerResult) {
        self.isAuto = false
        self.block = block
        self.imageArr = arr
        self.dataSource = arr.count
        self.indicator.numberOfPages = dataSource
        
        imageArr.enumerated().forEach { index, obj in
            let controller = UIViewController()
            controller.view.frame = self.bounds
            let imageView = UIImageView(frame: self.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: URL(string: obj)!)
            controller.view.addSubview(imageView)
            controlls.append(controller)
            
            setListener(for: imageView, at: index)
        }
        if let vc = pageControllerAtIndex(index: tagIndex) {
            pageCon.setViewControllers([vc], direction: .reverse, animated: true)
        }
    }
    
    /// 轮播自定义视图
    public func initCusViews(with arr: Array<UIView>, block: @escaping BannerResult) {
        self.isAuto = false
        self.block = block
        self.dataSource = arr.count
        self.indicator.numberOfPages = dataSource
        
        arr.enumerated().forEach { index, cusView in
            let controller = UIViewController()
            controller.view.frame = self.bounds
            cusView.frame = self.bounds
            controller.view.addSubview(cusView)
            controlls.append(controller)
            
            setListener(for: cusView, at: index)
        }
        
        if let vc = pageControllerAtIndex(index: tagIndex) {
            pageCon.setViewControllers([vc], direction: .reverse, animated: true)
        }
    }
    
    func setListener(for view: UIView, at index: Int) {
        view.tag = index
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func menuAction(_ sender: UITapGestureRecognizer) {
        let tappedView = sender.view!
        let index = tappedView.tag
        if let block = block {
            block(index)
        }
    }
    
}


extension ZKBanner: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let index = controlls.firstIndex(of: pageViewController.viewControllers!.first!) else { return }
         tagIndex = index
         indicator.currentPage = tagIndex
         if isAuto {
             openAuto()
         }
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        closeAuto()
    }
    
    public func openAuto() {
        isAuto = true
          
        timer = Timer.scheduledTimer(withTimeInterval: loop, repeats: true) { [weak self] _ in
              DispatchQueue.main.async {
                  guard let weakSelf = self else { return }
                  weakSelf.tagIndex += 1
                  if weakSelf.tagIndex > weakSelf.dataSource - 1 { // 最后一项
                      weakSelf.tagIndex = 0
                  }
                  
                  weakSelf.indicator.currentPage = weakSelf.tagIndex
                  if let vc = weakSelf.pageControllerAtIndex(index: weakSelf.tagIndex) {
                      weakSelf.pageCon.setViewControllers([vc], direction: .forward, animated: true)
                  }
                  
              }
          }
    }
    
    public func closeAuto() {
        if let timer = timer {
                isAuto = false
                timer.invalidate()
                self.timer = nil
            }
    }
}

extension ZKBanner: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //判断当前这个页面是第几个页面
        guard var index = controlls.index(of: viewController) else { return nil}
        
        //如果是第一个页面
        if(index==0){
            index = dataSource - 1
            
        }else{
            index -= 1
        }
        return pageControllerAtIndex(index: index)
        
    
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = self.controlls.firstIndex(of: viewController) else { return nil}
        
        if index == dataSource - 1 { // 最后一页
            index = 0
        } else {
            index += 1
        }
        return pageControllerAtIndex(index: index)
    }
    
    func pageControllerAtIndex(index: Int) -> UIViewController? {
        if !controlls.isEmpty {
            let controller = controlls[index]
            return controller
        } else {
            return nil
        }
    }
    
    
}
