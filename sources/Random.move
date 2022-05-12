module SFC::Random{
    use StarcoinFramework::Account;
    use StarcoinFramework::Block;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;
    use StarcoinFramework::BCS;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Hash;

    public fun seed(_account: &signer): u128 {
        let author: address = Block::get_current_author();
        let author_bytes: vector<u8> = BCS::to_bytes(&author);

        let timestamp: u64 = Timestamp::now_seconds();
        let timestamp_bytes: vector<u8> = BCS::to_bytes(&timestamp);

        let parent_hash: vector<u8> = Block::get_parent_hash();

        let sender: address = Signer::address_of(_account);
        let sender_bytes: vector<u8> = BCS::to_bytes(&sender);

        let sequence_number = Account::sequence_number(sender);
        let sequence_number_bytes = BCS::to_bytes(&sequence_number);

        let info: vector<u8> = Vector::empty<u8>();
        Vector::append<u8>(&mut info, author_bytes);
        Vector::append<u8>(&mut info, timestamp_bytes);
        Vector::append<u8>(&mut info, parent_hash);
        Vector::append<u8>(&mut info, sender_bytes);
        Vector::append<u8>(&mut info, sequence_number_bytes);

        let hash: vector<u8> = Hash::keccak_256(info);

        let _seed: u128 = 0u128;
        let i = 0;
        while (i < 16) {
            _seed = _seed | ((*Vector::borrow(&hash, i) as u128) << ((8*(15-i)) as u8));
            i = i + 1;
        };
        return _seed
    }

    // generate a random integer range in [0, n).
    public fun random(_account: &signer, n: u128): u128 {
        let _seed  = seed(_account);
        _seed % n
    }
}