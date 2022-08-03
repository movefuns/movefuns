/// @title Escrow
/// @dev Basic escrow module: holds an object designated for a recipient until the sender approves withdrawal.
module SFC::Escrow {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Option::{Self, Option};

    struct Escrow<T: key + store> has key {
        recipient: address,
        obj: Option<T>
    }

    /// @dev Stores the sent object in an escrow object.
    /// @param recipient The destination address of the escrowed object.
    public entry fun escrow<T: key + store>(sender: &signer, recipient: address, obj_in: T) {
        let escrow = Escrow<T> {
            recipient,
            obj: Option::some(obj_in)
        };
        move_to(sender, escrow);
    }

    /// @dev Transfers escrowed object to the recipient.
    public entry fun transfer<T: key + store>(sender: &signer) acquires Escrow {

        let escrow = move_from<Escrow<T>>(Signer::address_of(sender));
        let Escrow {
            recipient: recipient,
            obj: obj,
        } = escrow;
        let t_escrow = borrow_global_mut<Escrow<T>>(recipient);
        Option::fill(&mut t_escrow.obj, obj);
    }

    /// @dev Accepts the escrowed object.
    public entry fun accept<T: key + store>(recipient: &signer) {
        move_to(recipient, Escrow<T> {
            recipient: Signer::address_of(recipient),
            obj: Option::none(),
        });
    }
}