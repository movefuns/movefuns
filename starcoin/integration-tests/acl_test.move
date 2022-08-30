//# init -n test

//# faucet --addr alice

//# publish
module alice::ACLTest {
    use SFC::ACL;
    use StarcoinFramework::Signer;

    struct Data has key {
        value: u64,
        write_acl: ACL::ACL,
    }

    public(script) fun test_success(sender: signer){
        let acl = ACL::empty();
        ACL::add(&mut acl, Signer::address_of(&sender));
        move_to(&sender, Data {value: 0, write_acl: acl});
    }

    public(script) fun test_add_failure(sender: signer) acquires Data  {
        let acl = ACL::empty();
        ACL::add(&mut acl, Signer::address_of(&sender));
        move_to(&sender, Data {value: 0, write_acl: acl});

        let sender_data = borrow_global_mut<Data>(Signer::address_of(&sender));
        ACL::add(&mut sender_data.write_acl, Signer::address_of(&sender));
    }
}


//# run --signers alice
script {
    use alice::ACLTest;

    fun main(sender: signer) {
       ACLTest::test_success(sender);
    }
}
//check : Executed

//# run --signers alice
script {
    use alice::ACLTest;

    fun main(sender: signer) {
       ACLTest::test_add_failure(sender);
    }
}
//check : code_offset 10
