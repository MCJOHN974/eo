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

/*
 * @checkstyle PackageNameCheck (4 lines)
 */
package EOorg.EOeolang;

import java.math.BigInteger;
import org.eolang.AtComposite;
import org.eolang.AtVararg;
import org.eolang.Bytes;
import org.eolang.BytesOf;
import org.eolang.Data;
import org.eolang.Dataized;
import org.eolang.ExFailure;
import org.eolang.Param;
import org.eolang.PhDefault;
import org.eolang.Phi;
import org.eolang.XmirObject;

/**
 * BYTES.AND.
 *
 * @since 1.0
 * @checkstyle TypeNameCheck (5 lines)
 */
@XmirObject(oname = "bytes.and")
public class EObytes$EOand extends PhDefault {

    /**
     * Ctor.
     * @param sigma Sigma
     */
    public EObytes$EOand(final Phi sigma) {
        super(sigma);
        this.add("b", new AtVararg());
        this.add(
            "φ",
            new AtComposite(
                this,
                rho -> {
                    Bytes base = new Param(rho).asBytes();
                    final Phi[] args = new Param(rho, "b").strong(Phi[].class);
                    for (int index = 0; index < args.length; ++index) {
                        final Object val = new Dataized(args[index]).take();
                        if (!(val instanceof byte[])) {
                            throw new ExFailure(
                                String.format(
                                    "The %dth argument of 'and' is of type %s, not bytes",
                                    index, val.getClass().getCanonicalName()
                                )
                            );
                        }
                        base = base.and(new BytesOf(byte[].class.cast(val)));
                    }
                    return new Data.ToPhi(base.take());
                }
            )
        );
    }

}
