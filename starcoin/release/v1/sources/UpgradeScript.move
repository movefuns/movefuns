module SFC::UpgradeScript {
    use SFC::PseudoRandom;

    public(script) fun v1_init(account: signer) {
        PseudoRandom::init(&account);
    }
}