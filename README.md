#  ZKBanner

一个采用UIPageViewController实现的轮播横幅（Banner）

<img src="https://github.com/user-attachments/assets/f5d6717f-5fa7-4246-b2bf-3846922a2d59" alt="RocketSim_Recording_iPhone_16_Pro_6 3_2024-10-09_03 56 44" style="zoom:50%;" />


## 功能
1. 页面内容可以自定义：可以是图片轮播,也可以是其他view;
2. 可以实现定时自动轮播;
3. 能处理轮播页的点击事件;

## 使用方法
``` swift
class BannerVC: UIViewController {
    
    var banner1: ZKBanner!
    
    var banner2: ZKBanner!
    
    override func viewDidLoad() {
        setBanner1()
        setBanner2()
    }
    
    func setBanner1() {
        let label1 = UILabel()
        label1.text = "图片轮播"
        view.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.left.equalToSuperview()
        }
        // 需要先给定一个基准frame，否则使用Snapkit的话无法准确渲染图片（因为Snapkit布局时可能图片已经根据`.zero`的 `frame` 加载了）
        banner1 = ZKBanner(frame: CGRectMake(0, 0, self.view.bounds.size.width, 200))
        view.addSubview(banner1)
        banner1.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        // 可以对指示器进行重新布局
        banner1.indicator.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(8)
        }
        
        let images = [
            "https://images.unsplash.com/photo-1720048171596-6a7c81662434?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://img0.baidu.com/it/u=597753977,1250737874&fm=253&fmt=auto&app=120&f=JPEG?w=801&h=500",
            "https://img1.baidu.com/it/u=1795072984,4227544674&fm=253&fmt=auto&app=120&f=JPEG?w=654&h=363",
            "https://i2.hdslb.com/bfs/archive/b4c0c3907e1f64c2de50edb35a7524d3af48e0f8.jpg"
        ]
        
        banner1.backgroundColor = .gray
        banner1.initImages(with: images) { index in
            print("点击了\(index)页")
        }
        banner1.openAuto()
    }
    
    func setBanner2() {
        let label2 = UILabel()
        label2.text = "自定义View轮播"
        view.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(banner1.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.left.equalToSuperview()
        }
        banner2 = ZKBanner(frame: CGRectMake(0, 0, self.view.bounds.size.width, 200))
        view.addSubview(banner2)
        banner2.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        // 可以对指示器进行重新布局
        banner2.indicator.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(8)
        }
        
        let view1 = UIView()
        view1.backgroundColor = .red
        let view2 = UIView()
        view2.backgroundColor = .black
        let view3 = UIView()
        view3.backgroundColor = .brown
        let view4 = UIView()
        view4.backgroundColor = .cyan
        let view5 = UIView()
        view5.backgroundColor = .green
        let arr = [ view1, view2, view3, view4, view5
        ]
        
        banner2.backgroundColor = .gray
        banner2.initCusViews(with: arr) { index in
            
        }
    }
    
}

```

## 灵感来源：

https://www.jianshu.com/p/ad8ec0781cd9

## TODO:

- [ ] 纯swiftUI实现的轮播横幅

