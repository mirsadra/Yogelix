//  CircleView.swift
import SwiftUI


struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
            // Add this frame modifier to center the image
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("catPose"))
    }
}
