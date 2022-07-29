module SFC::TimeHelper {
    const SECOND_IN_MILLISECONDS: u64 = 1000;
    const MINUTE_IN_MILLISECONDS: u64 = 1000 * 60;
    const HOUR_IN_MILLISECONDS: u64 = 1000 * 60 * 60;
    const DAY_IN_MILLISECONDS: u64 = 1000 * 60 * 60 * 24;
    const WEEK_IN_MILLISECONDS: u64 = 1000 * 60 * 60 * 24 * 7;

    const SECOND_IN_SECONDS: u64 = 1;
    const MINUTE_IN_SECONDS: u64 = 1 * 60;
    const HOUR_IN_SECONDS: u64 = 1 * 60 * 60;
    const DAY_IN_SECONDS: u64 = 1 * 60 * 60 * 24;
    const WEEK_IN_SECONDS: u64 = 1 * 60 * 60 * 24 * 7;

    public fun add_days(timestamp: u64, days: u64): u64 {
        add(timestamp, DAY_IN_MILLISECONDS * days)
    }

    public fun add_hours(timestamp: u64, hours: u64): u64 {
        add(timestamp, HOUR_IN_MILLISECONDS * hours)
    }

    public fun add_minutes(timestamp: u64, minutes: u64): u64 {
        add(timestamp, MINUTE_IN_MILLISECONDS * minutes)
    }

    public fun add_seconds(timestamp: u64, seconds: u64): u64 {
        add(timestamp, SECOND_IN_MILLISECONDS * seconds)
    }

    public fun add_weeks(timestamp: u64, week: u64): u64 {
        add(timestamp, WEEK_IN_MILLISECONDS * week)
    }

    public fun add_days_for_seconds(timestamp: u64, days: u64): u64 {
        add(timestamp, DAY_IN_SECONDS * days)
    }

    public fun add_hours_for_seconds(timestamp: u64, hours: u64): u64 {
        add(timestamp, HOUR_IN_SECONDS * hours)
    }

    public fun add_seconds_for_seconds(timestamp: u64, seconds: u64): u64 {
        add(timestamp, SECOND_IN_SECONDS * seconds)
    }

    public fun add_weeks_for_seconds(timestamp: u64, week: u64): u64 {
        add(timestamp, WEEK_IN_SECONDS * week)
    }

    public fun add_minutes_for_seconds(timestamp: u64, minutes: u64): u64 {
        add(timestamp, MINUTE_IN_SECONDS * minutes)
    }

    fun add(timestamp: u64, milliseconds: u64): u64 {
        timestamp + milliseconds
    }
}