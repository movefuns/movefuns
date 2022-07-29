//# init -n test

//# faucet --addr alice --amount 100000000000

//# block --author 0x1 --timestamp 1659075272000

//# run --signers alice
script {
    use SFC::TimeHelper;
    use StarcoinFramework::Timestamp;

    fun main() {
        assert!(TimeHelper::add_days(Timestamp::now_milliseconds(), 1) == 1659161672000, 1001);
        assert!(TimeHelper::add_weeks(Timestamp::now_milliseconds(), 1) == 1659680072000, 1002);
        assert!(TimeHelper::add_hours(Timestamp::now_milliseconds(), 1) == 1659078872000, 1003);
        assert!(TimeHelper::add_minutes(Timestamp::now_milliseconds(), 1) == 1659075332000, 1004);
        assert!(TimeHelper::add_seconds_for_seconds(Timestamp::now_seconds(), 1) == 1659075273, 1013);
        assert!(TimeHelper::add_days_for_seconds(Timestamp::now_seconds(), 1) == 1659161672, 1011);
        assert!(TimeHelper::add_weeks_for_seconds(Timestamp::now_seconds(), 1) == 1659680072, 1012);
        assert!(TimeHelper::add_hours_for_seconds(Timestamp::now_seconds(), 1) == 1659078872, 1013);
        assert!(TimeHelper::add_minutes_for_seconds(Timestamp::now_seconds(), 1) == 1659075332, 1014);
        assert!(TimeHelper::add_seconds_for_seconds(Timestamp::now_seconds(), 1) == 1659075273, 1015);
    }
}
// check: EXECUTED
