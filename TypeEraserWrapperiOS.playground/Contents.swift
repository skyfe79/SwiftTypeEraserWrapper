import UIKit

protocol Component {
    associatedtype Content
    var id: String { get }
    func contentView() -> Content
    func layoutSize() -> CGSize
}

// Component 프로토콜을 구체 제네릭 클래스에 채택하여 구현한다.
// 이 클래스는 abstract class로 만드는데 이 클래스를 상속하여 Component Box를 만들기 때문이다.
private class AnyComponentBase<Content>: Component {
    var id: String { fatalError("implement it!") }
    
    func contentView() -> Content {
        fatalError("implement it!")
    }
    
    func layoutSize() -> CGSize {
        fatalError("implement it!")
    }
}

// Component를 채택한 구체 타입 컴포넌트를 담는 Box 클래스다.
// 위에서 정의한 제네릭 구체 클래스인 AnyComponentBase로부터 상속 받는다.
// AnyComponentBase의 Content 제네릭 타입은 구체 컴포넌트인 ConcreteComponent의 Content로 설정한다.
private class AnyComponentBox<ConcreteComponent: Component>: AnyComponentBase<ConcreteComponent.Content> {
    
    var concrete: ConcreteComponent
    
    init(_ concrete: ConcreteComponent) {
        self.concrete = concrete
    }
    
    override var id: String {
        return concrete.id
    }
    
    override func contentView() -> ConcreteComponent.Content {
        return concrete.contentView()
    }
    
    override func layoutSize() -> CGSize {
        return concrete.layoutSize()
    }
}

// 실제로 사용할 Type Erasure Wrapper다.
public class AnyComponent<Content>: Component {
    // Content를 담는 컴포넌트 박스를 표현해야 하므로
    // Abstract class 포인터로 Box를 가리키게 한다.
    private let box: AnyComponentBase<Content>
    
    init<ConcreteComponent: Component>(_ concrete: ConcreteComponent) where ConcreteComponent.Content == Content {
        self.box = AnyComponentBox(concrete);
    }
    
    var id: String {
        return box.id
    }

    func contentView() -> Content {
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
    func contentView() -> UIView {
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
    func contentView() -> UIView {
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
    func contentView() -> UIView {
        return UISwitch(frame: .zero)
    }
    func layoutSize() -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}


let components: [AnyComponent<UIView>] = [
    AnyComponent(LabelComponent()),
    AnyComponent(ButtonComponent()),
    AnyComponent(SwitchComponent())
]


components.forEach { component in
    print(component.id)
    print(component.contentView())
    print(component.layoutSize())
    print()
}
