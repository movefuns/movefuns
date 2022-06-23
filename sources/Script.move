module SFC::Script {
    use SFC::PseudoRandom;

    public(script) fun PseudoRandom_init(account: signer) {
        PseudoRandom::init(&account);
    }
}