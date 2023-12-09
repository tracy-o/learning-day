#!/usr/bin/env node

const yargs = require("yargs");

const options = yargs
 .usage("Usage: -n <name> -m <match>")
 .option("n", { alias: "name", describe: "Your username", type: "string", demandOption: false })
 .option("m", { alias: "match", describe: "Search Confluence Wikis for a term", type: "any", demandOption: false })
 .option("t", { alias: "token", describe: "Set token", type: "any", demandOption: false })
//  .help(true)
 .argv;

const greeting = `Hello, ${options.name || "you"}!`;
const pages = new Map([
    ["home", "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage"],
    ["test", "https://www.example.com"]
]);

if (options.name) {
    console.log(greeting);
};

if (options.match) {
    fetch(pages.get("home"))
    .then((response) => response.json())
    .then((json) => console.log(json));
};
