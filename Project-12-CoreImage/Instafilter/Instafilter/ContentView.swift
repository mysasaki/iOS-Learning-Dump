//
//  ContentView.swift
//  Instafilter
//
//  Created by Mylla Sasaki on 18/05/26.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var processedImage: Image?
    @State private var inputImage: UIImage?
    @State private var showingFilters = false
    
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    var hasImage: Bool {
        processedImage != nil
    }
    
    var enabledIntensity: Bool {
        let inputKeys = currentFilter.inputKeys
        return hasImage && inputKeys.contains(kCIInputIntensityKey)
    }
    
    var enabledRadius: Bool {
        let inputKeys = currentFilter.inputKeys
        return hasImage && inputKeys.contains(kCIInputRadiusKey)
    }
    
    var enabledScale: Bool {
        let inputKeys = currentFilter.inputKeys
        return hasImage && inputKeys.contains(kCIInputScaleKey)
    }
    
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    }
                    else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .onChange(of: selectedItem) {
                    loadImage()
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .disabled(!enabledIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                }
                .padding(.vertical)
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .disabled(!enabledRadius)
                        .onChange(of: filterRadius, applyProcessing)
                }
                .padding(.vertical)
                
                HStack {
                    Text("Scale")
                    Slider(value: $filterScale)
                        .disabled(!enabledScale)
                        .onChange(of: filterScale, applyProcessing)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change filter", action: changeFilter)
                        .disabled(!hasImage)
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("ÏnstaFilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixelate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: imageData) else { return }
            
            inputImage = uiImage

            let beginImage = CIImage(image: uiImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        
        if enabledIntensity { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
        
        if enabledRadius { currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)}
        
        if enabledScale {currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)}
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        
        guard let inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        
        filterCount += 1
        if filterCount >= 20 {
            requestReview()
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
}

#Preview {
    ContentView()
}
