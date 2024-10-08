//
//  ContentView.swift
//  demo
//
//  Created by 雷子康 on 2024/10/8.
//

import SwiftUI
import ZKBanner

struct ContentView: View {
    var body: some View {
        ZKBannerView()
            .padding()
    }
}

struct ZKBannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let vc = UIViewController()
        // 需要先给定一个基准frame，否则使用Snapkit的话无法准确渲染图片（因为Snapkit布局时可能图片已经加载了）
        let banner = ZKBanner(frame: CGRectMake(0, 0, vc.view.bounds.size.width, 200))
        vc.view.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.top.centerX.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        // 可以对指示器进行重新布局
        banner.indicator.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(8)
        }
        
        let arr = [
            "https://images.unsplash.com/photo-1720048171596-6a7c81662434?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://img0.baidu.com/it/u=597753977,1250737874&fm=253&fmt=auto&app=120&f=JPEG?w=801&h=500",
            "https://img1.baidu.com/it/u=1795072984,4227544674&fm=253&fmt=auto&app=120&f=JPEG?w=654&h=363",
            "https://i2.hdslb.com/bfs/archive/b4c0c3907e1f64c2de50edb35a7524d3af48e0f8.jpg"
        ]
        
        banner.backgroundColor = .gray
        banner.initData(arr: arr) { index in
            print("点击了\(index)页")
        }
        banner.openAuto()
        
        
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

#Preview {
    ContentView()
}
