import Foundation

struct ActorItemCollectionViewCellViewModel {
    let actorImageURLString: String
    let actorNameText: String
    
    init(actor: Actor) {
        actorImageURLString = actor.image ?? ""
        actorNameText = actor.name ?? ""
    }
}
