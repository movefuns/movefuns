
<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::TimeHelper`



-  [Constants](#@Constants_0)
-  [Function `days_in_milliseconds`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days_in_milliseconds)
-  [Function `hours_in_milliseconds`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours_in_milliseconds)
-  [Function `minutes_in_milliseconds`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes_in_milliseconds)
-  [Function `seconds_in_milliseconds`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds_in_milliseconds)
-  [Function `weeks_in_milliseconds`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks_in_milliseconds)
-  [Function `days`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days)
-  [Function `hours`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours)
-  [Function `seconds`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds)
-  [Function `weeks`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks)
-  [Function `minutes`](#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes)


<pre><code></code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_DAY_IN_MILLISECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_DAY_IN_MILLISECONDS">DAY_IN_MILLISECONDS</a>: u64 = 86400000;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_DAY_IN_SECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_DAY_IN_SECONDS">DAY_IN_SECONDS</a>: u64 = 86400;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_HOUR_IN_MILLISECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_HOUR_IN_MILLISECONDS">HOUR_IN_MILLISECONDS</a>: u64 = 3600000;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_HOUR_IN_SECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_HOUR_IN_SECONDS">HOUR_IN_SECONDS</a>: u64 = 3600;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_MINUTE_IN_MILLISECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_MINUTE_IN_MILLISECONDS">MINUTE_IN_MILLISECONDS</a>: u64 = 60000;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_MINUTE_IN_SECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_MINUTE_IN_SECONDS">MINUTE_IN_SECONDS</a>: u64 = 60;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_SECOND_IN_MILLISECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_SECOND_IN_MILLISECONDS">SECOND_IN_MILLISECONDS</a>: u64 = 1000;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_SECOND_IN_SECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_SECOND_IN_SECONDS">SECOND_IN_SECONDS</a>: u64 = 1;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_WEEK_IN_MILLISECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_WEEK_IN_MILLISECONDS">WEEK_IN_MILLISECONDS</a>: u64 = 604800000;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_WEEK_IN_SECONDS"></a>



<pre><code><b>const</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_WEEK_IN_SECONDS">WEEK_IN_SECONDS</a>: u64 = 604800;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days_in_milliseconds"></a>

## Function `days_in_milliseconds`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days_in_milliseconds">days_in_milliseconds</a>(days: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days_in_milliseconds">days_in_milliseconds</a>(days: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_DAY_IN_MILLISECONDS">DAY_IN_MILLISECONDS</a> * days
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours_in_milliseconds"></a>

## Function `hours_in_milliseconds`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours_in_milliseconds">hours_in_milliseconds</a>(hours: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours_in_milliseconds">hours_in_milliseconds</a>(hours: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_HOUR_IN_MILLISECONDS">HOUR_IN_MILLISECONDS</a> * hours
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes_in_milliseconds"></a>

## Function `minutes_in_milliseconds`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes_in_milliseconds">minutes_in_milliseconds</a>(minutes: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes_in_milliseconds">minutes_in_milliseconds</a>(minutes: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_MINUTE_IN_MILLISECONDS">MINUTE_IN_MILLISECONDS</a> * minutes
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds_in_milliseconds"></a>

## Function `seconds_in_milliseconds`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds_in_milliseconds">seconds_in_milliseconds</a>(seconds: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds_in_milliseconds">seconds_in_milliseconds</a>(seconds: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_SECOND_IN_MILLISECONDS">SECOND_IN_MILLISECONDS</a> * seconds
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks_in_milliseconds"></a>

## Function `weeks_in_milliseconds`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks_in_milliseconds">weeks_in_milliseconds</a>(week: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks_in_milliseconds">weeks_in_milliseconds</a>(week: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_WEEK_IN_MILLISECONDS">WEEK_IN_MILLISECONDS</a> * week
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days"></a>

## Function `days`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days">days</a>(days: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_days">days</a>(days: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_DAY_IN_SECONDS">DAY_IN_SECONDS</a> * days
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours"></a>

## Function `hours`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours">hours</a>(hours: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_hours">hours</a>(hours: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_HOUR_IN_SECONDS">HOUR_IN_SECONDS</a> * hours
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds"></a>

## Function `seconds`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds">seconds</a>(seconds: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_seconds">seconds</a>(seconds: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_SECOND_IN_SECONDS">SECOND_IN_SECONDS</a> * seconds
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks"></a>

## Function `weeks`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks">weeks</a>(week: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_weeks">weeks</a>(week: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_WEEK_IN_SECONDS">WEEK_IN_SECONDS</a> * week
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes"></a>

## Function `minutes`



<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes">minutes</a>(minutes: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_minutes">minutes</a>(minutes: u64): u64 {
    <a href="TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper_MINUTE_IN_SECONDS">MINUTE_IN_SECONDS</a> * minutes
}
</code></pre>



</details>
