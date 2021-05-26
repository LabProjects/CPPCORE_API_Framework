package cpp.features;

import com.intuit.karate.junit5.Karate;

class FeaturesRunner {
    
    @Karate.Test
    Karate PayPointBFFtests() {
        return Karate.run("PayPointBFF").relativeTo(getClass());
    }
    @Karate.Test
    Karate CloudPaymentPlatformtests() {
        return Karate.run("CloudPaymentPlatform").relativeTo(getClass());
    }
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
    @Karate.Test
    Karate testTags() {
        return Karate.run("tags").tags("@ServiceTest").relativeTo(getClass());
    }
}
