//
//  ARViewContainer.swift
//  ARCounter
//
//  Created by Andronick Martusheff on 6/25/22.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var count: Count
    
    func makeUIView(context: Context) -> ARView {
        return ARView(frame: .zero, cameraMode: ARView.CameraMode.nonAR, automaticallyConfigureSession: true)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        updateCounter(uiView: uiView)
    }
    
    private func updateCounter(uiView: ARView) {
        uiView.scene.anchors.removeAll()
        uiView.renderOptions.insert(ARView.RenderOptions.disableCameraGrain)
        
        let skyboxName = "rural_crossroads_1k"
        let skyboxResource = try! EnvironmentResource.load(named: skyboxName)
        uiView.environment.lighting.resource = skyboxResource
        uiView.environment.lighting.intensityExponent = 1
        uiView.environment.background = .skybox(skyboxResource)
        
        let tDirLight = DirectionalLight()
        tDirLight.light.intensity = 10000
        tDirLight.shadow = DirectionalLightComponent.Shadow(maximumDistance: 20.0, depthBias: 1.0)
        
        let tLightAnchor = AnchorEntity(world: [0, 5, 0])
        let radians = 90.0 * Float.pi / 180.0
        tLightAnchor.transform.rotation = simd_quatf(angle: -radians, axis: SIMD3(x: 1, y: 0, z: 0))
        tLightAnchor.addChild(tDirLight)
        uiView.scene.addAnchor(tLightAnchor)
        
        let tPlaneMesh = MeshResource.generatePlane(width: 10, depth: 10)
        let tPlaneMaterial = SimpleMaterial(color: .white, roughness: 0.3, isMetallic: true)
        let tPlaneEntity = ModelEntity(mesh: tPlaneMesh, materials: [tPlaneMaterial])
        let tPlaneAnchor = AnchorEntity(world: [0, 0, 0])
        tPlaneAnchor.addChild(tPlaneEntity)
        uiView.scene.addAnchor(tPlaneAnchor)
        
        let tSphereMesh = MeshResource.generateSphere(radius: 1.5)
        let tSphereMaterial = SimpleMaterial(color: .white, roughness: 0.0, isMetallic: true)
        let tSphereEntity = ModelEntity(mesh: tSphereMesh, materials: [tSphereMaterial])
        let tSphereAnchor = AnchorEntity(world: [0, 2, -1])
        tSphereAnchor.addChild(tSphereEntity)
        uiView.scene.addAnchor(tSphereAnchor)
        
        let tCamera = PerspectiveCamera()
        let tCameraAnchor = AnchorEntity(world: [0, 1, 5])
        tCameraAnchor.addChild(tCamera)
        uiView.scene.addAnchor(tCameraAnchor)
        
//        let anchor = AnchorEntity()
//        let text = MeshResource.generateText(
//            "\(abs(count.num))",
//            extrusionDepth: 0.08,
//            font: .systemFont(ofSize: 0.5, weight: .bold)
//        )
//        
//        let color: UIColor
//        
//        switch count.num {
//        case let x where x < 0:
//            color = .red
//        case let x where x > 0:
//            color = .green
//        default:
//            color = .white
//        }
//
//        let shader = SimpleMaterial(color: color, roughness: 4, isMetallic: true)
//        let textEntity = ModelEntity(mesh: text, materials: [shader])
//
//        textEntity.position.z -= 1.5
//        textEntity.setParent(anchor)
//        uiView.scene.addAnchor(anchor)
    }
}
