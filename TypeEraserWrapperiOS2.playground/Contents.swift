import UIKit

protocol Component {
    associatedtype Content
    var id: String { get }
    func contentView() -> Content
    func layoutSize() -> CGSize
}

private protocol AnyComponentBase {
    var id: String { get }
    func contentView() -> Any
    func layoutSize() -> CGSize
}

private struct AnyComponentBox<ConcreteComponent: Component>: AnyComponentBase {
    var concrete: ConcreteComponent
    
    var id: String {
        return concrete.id
    }
    
    func contentView() -> Any {
        return concrete.contentView()
    }
    
    func layoutSize() -> CGSize {
        return concrete.layoutSize()
    }
    
    init(_ concrete: ConcreteComponent) {
        self.concrete = concrete
    }
}

public struct AnyComponent: Component {
    private let box: AnyComponentBase
    init<ConcreteComponent: Component>(_ concrete: ConcreteComponent) {
        if let anyComponent = concrete as? AnyComponent {
            self = anyComponent
        } else {
            box = AnyComponentBox(concrete)
        }
    }
    
    var id: String {
        return box.id
    }
    
    func contentView() -> Any {
        return box.contentView()
    }
    
    func layoutSize() -> CGSize {
        return box.layoutSize()
    }
}

struct LabelComponent: Component {
    var id: String {
        return "MyLabel"
    }
    func contentView() -> UILabel {
        return UILabel(frame: .zero)
    }
    func layoutSize() -> CGSize {
        return CGSize(width: 100, height: 50)
    }
}

struct ButtonComponent: Component {
    var id: String {
        return "MyButton"
    }
    func contentView() -> UIButton {
        return UIButton(frame: .zero)
    }
    func layoutSize() -> CGSize {
        return CGSize(width: 200, height: 100)
    }
}

struct SwitchComponent: Component {
    var id: String {
        return "MySwitch"
    }
    func contentView() -> UISwitch {
        return UISwitch(frame: .zero)
    }
    func layoutSize() -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

extension Component {
    func eraseToAnyComponent() -> AnyComponent {
        return AnyComponent(self)
    }
}


let components: [AnyComponent] = [
    AnyComponent(AnyComponent(LabelComponent())),
    AnyComponent(AnyComponent(AnyComponent(ButtonComponent()))),
    AnyComponent(AnyComponent(AnyComponent(AnyComponent(SwitchComponent())))),
    LabelComponent().eraseToAnyComponent()
]

components.forEach { component in
    print(component.id)
    print(component.contentView())
    print(component.layoutSize())
    print()
}

let components2 = [
    LabelComponent().eraseToAnyComponent(),
    ButtonComponent().eraseToAnyComponent(),
    SwitchComponent().eraseToAnyComponent()
]

components2.forEach { component in
    print(component.id)
    print(component.contentView())
    print(component.layoutSize())
    print()
}

