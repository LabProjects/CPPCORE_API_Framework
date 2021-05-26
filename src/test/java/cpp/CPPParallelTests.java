package cpp;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

class CPPParallelTests {

    @Test
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
}
