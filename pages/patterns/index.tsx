import {NextPage} from "next";
import Link from "next/link";

const PatternsPage: NextPage = () => {
    return (
        <div>
            <h1>Patterns</h1>

            <p><Link href="/patterns/sample">Sample pattern</Link></p>
        </div>
    )
}

export default PatternsPage
