/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016-2022 Objectionary.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package org.eolang.maven;

import com.yegor256.tojos.Csv;
import com.yegor256.tojos.MonoTojos;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.hamcrest.MatcherAssert;
import org.hamcrest.Matchers;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

/**
 * Test case for {@link UnplaceMojo}.
 *
 * @since 0.1
 * @checkstyle LocalFinalVariableNameCheck (100 lines)
 */
final class UnplaceMojoTest {

    @Test
    void testCleaning(@TempDir final Path temp) throws Exception {
        final Path foo = temp.resolve("a/b/c/foo.class");
        new Save("...", foo).save();
        final Path pparent = foo.getParent().getParent();
        final Path foo2 = temp.resolve("a/b/c/foo2.class");
        new Save("...", foo2).save();
        final Path foo3 = temp.resolve("a/b/c/d/foo3.class");
        new Save("...", foo3).save();
        final Path foo4 = temp.resolve("a/b/c/e/foo4.class");
        new Save("...", foo4).save();
        final Path list = temp.resolve("placed.json");
        new MonoTojos(new Csv(list)).add(foo.toString())
            .set(PlaceMojo.ATTR_KIND, "class")
            .set(PlaceMojo.ATTR_RELATED, "---")
            .set(PlaceMojo.ATTR_ORIGIN, "some.jar")
            .set(PlaceMojo.ATTR_HASH, new FileHash(foo));
        new MonoTojos(new Csv(list)).add(foo2.toString())
            .set(PlaceMojo.ATTR_KIND, "class")
            .set(PlaceMojo.ATTR_RELATED, "---")
            .set(PlaceMojo.ATTR_ORIGIN, "some.jar")
            .set(PlaceMojo.ATTR_HASH, new FileHash(foo2));
        new MonoTojos(new Csv(list)).add(foo3.toString())
            .set(PlaceMojo.ATTR_KIND, "class")
            .set(PlaceMojo.ATTR_RELATED, "---")
            .set(PlaceMojo.ATTR_ORIGIN, "some.jar")
            .set(PlaceMojo.ATTR_HASH, new FileHash(foo3));
        new MonoTojos(new Csv(list)).add(foo4.toString())
            .set(PlaceMojo.ATTR_KIND, "class")
            .set(PlaceMojo.ATTR_RELATED, "---")
            .set(PlaceMojo.ATTR_ORIGIN, "some.jar")
            .set(PlaceMojo.ATTR_HASH, new FileHash(foo4));
        new Moja<>(UnplaceMojo.class)
            .with("placed", list.toFile())
            .with("placedFormat", "csv")
            .execute();
        MatcherAssert.assertThat(
            Files.exists(foo),
            Matchers.is(false)
        );
        MatcherAssert.assertThat(
            Files.exists(foo2),
            Matchers.is(false)
        );
        MatcherAssert.assertThat(
            Files.exists(foo3),
            Matchers.is(false)
        );
        MatcherAssert.assertThat(
            Files.exists(foo4),
            Matchers.is(false)
        );
        MatcherAssert.assertThat(
            Files.exists(Paths.get(String.valueOf(pparent))),
            Matchers.is(false)
        );
    }
}
