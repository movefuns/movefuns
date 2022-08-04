/// @title Escrow
/// @dev Basic escrow module: holds an object designated for a recipient until the sender approves withdrawal.
module SFC::Escrow {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Option::{Self, Option};

    struct Escrow<T: store> has key {
        recipient: address,
        obj: Option<T>
    }

    /// @dev Stores the sent object in an escrow object.
    /// @param recipient The destination address of the escrowed object.
    public fun escrow<T: store>(sender: &signer, recipient: address, obj_in: T) {
        let escrow = Escrow<T> {
            recipient,
            obj: Option::some(obj_in)
        };
        move_to(sender, escrow);
    }

    /// @dev Transfers escrowed object to the recipient.
    public fun transfer<T: store>(sender: &signer) acquires Escrow {

        let escrow = move_from<Escrow<T>>(Signer::address_of(sender));
        let Escrow {
            recipient: recipient,
            obj: obj,
        } = escrow;
        let t_escrow = borrow_global_mut<Escrow<T>>(recipient);
        let obj_in = Option::destroy_some(obj);
        Option::fill(&mut t_escrow.obj, obj_in);
    }

    /// @dev Accepts the escrowed object.
    public fun accept<T: store>(recipient: &signer) {
        move_to(recipient, Escrow<T> {
            recipient: Signer::address_of(recipient),
            obj: Option::none<T>(),
        });
    }

    public fun contains<T: store>(account: address): bool acquires Escrow {
        if (exists<Escrow<T>>(account) == false) return false;
        let escrow = borrow_global<Escrow<T>>(account);
        Option::is_some(&escrow.obj)
    }
}