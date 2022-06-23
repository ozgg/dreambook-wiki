import {NextPage} from "next";
import Link from "next/link";

const PatternPage: NextPage = () => {
    return (
        <div>
            <h1>Pattern description</h1>

            <p><Link href="/patterns">All patterns</Link></p>
        </div>
    )
}

export default PatternPage
