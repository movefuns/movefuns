/// @title Escrow
/// @dev Basic escrow module: holds an object designated for a recipient until the sender approves withdrawal.
module SFC::Escrow {

    use StarcoinFramework::Signer;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Errors;

    const ERR_INDEX_OUT_OF_RANGE: u64 = 0;

    struct Escrow<T: store> has store {
        recipient: address,
        obj: T,
        claimable: bool
    }

    struct EscrowContainer<T: store> has key {
        escrows: vector<Escrow<T>>
    }

    /// @dev Stores the sent object in an escrow container object.
    /// @param recipient The destination address of the escrowed object.
    public fun escrow<T: store>(sender: &signer, recipient: address, obj_in: T) acquires EscrowContainer {
        let sender_addr = Signer::address_of(sender);

        let escrow = Escrow<T> {
            recipient,
            obj: obj_in,
            claimable: false,
        };

        if (!exists<EscrowContainer<T>>(sender_addr)){
            let escrow_container = EscrowContainer<T>{ escrows: Vector::empty<Escrow<T>>() };
            Vector::push_back<Escrow<T>>(&mut escrow_container.escrows, escrow);
            move_to<EscrowContainer<T>>(sender, escrow_container);
        } else {
            let escrow_container = borrow_global_mut<EscrowContainer<T>>(sender_addr);
            Vector::push_back<Escrow<T>>(&mut escrow_container.escrows, escrow);
        }
    }

    /// @dev Claim escrowed object to the recipient.
    public fun claim<T: store>(account: &signer, sender: address): vector<T> acquires EscrowContainer {
        let account_addr = Signer::address_of(account);

        let escrows = Vector::empty<T>();
        
        let escrow_container = borrow_global_mut<EscrowContainer<T>>(sender);
        if (!Vector::is_empty<Escrow<T>>(&escrow_container.escrows)) {
            let escrow_len = Vector::length<Escrow<T>>(&escrow_container.escrows);
            let i = 0;
            while (i < escrow_len) {
                let escrow = Vector::borrow(&escrow_container.escrows, i);
                if (escrow.recipient == account_addr && escrow.claimable) {
                    let Escrow { obj: t, recipient: _, claimable: _ } = Vector::remove<Escrow<T>>(&mut escrow_container.escrows, i);
                    Vector::push_back<T>(&mut escrows, t);
                    escrow_len = escrow_len - 1;
                } else {
                    i = i + 1;
                }
            }
        };
        escrows
    }

    /// @dev make escrowed object claimable at index.
    public fun set_claimable<T: store>(sender: &signer, index: u64) acquires EscrowContainer {
        let sender_addr = Signer::address_of(sender);

        let escrow_container = borrow_global_mut<EscrowContainer<T>>(sender_addr);
        if (!Vector::is_empty<Escrow<T>>(&escrow_container.escrows)) {
            let escrow_len = Vector::length<Escrow<T>>(&escrow_container.escrows);
            assert!(index < escrow_len, Errors::invalid_argument(ERR_INDEX_OUT_OF_RANGE));
            let escrow = Vector::borrow_mut(&mut escrow_container.escrows, index);
            escrow.claimable = true;
        }
    }

    /// @dev Check if there is an escrow object in sender address for recipient.
    public fun contains<T: store>(sender: address, recipient: address): bool acquires EscrowContainer {
        if (!exists<EscrowContainer<T>>(sender)) { return false };
        let escrow_container = borrow_global_mut<EscrowContainer<T>>(sender);
        if (!Vector::is_empty<Escrow<T>>(&escrow_container.escrows)) {
            let escrow_len = Vector::length<Escrow<T>>(&escrow_container.escrows);
            let i = 0;
            while (i < escrow_len) {
                let escrow = Vector::borrow(&escrow_container.escrows, i);
                if (escrow.recipient == recipient) {
                    return true
                } else {
                    i = i + 1;
                }
            }
        };
        false
    }
}
