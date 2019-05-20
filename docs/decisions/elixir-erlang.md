# Elixir & Erlang

EElixir compiles to Erlang with no performance loss. Erlang's design goals are to abstract away many of the problems of designing and deploying highly available, concurrent, fault-tolerant systems.

## The Web is concurrent

When you access a website there is little concurrency involved. A few connections are opened and requests are sent through these connections. Then the web page is displayed on your screen. Ingress will only open a connection to the downstream server, and then send back the output to the browser. This isn't much.
But think about it. You are not the only one accessing the server at the same time. There can be hundreds, if not thousands, if not millions of connections to the same server at the same time.

Erlang has no problem handling millions of connections. Servers written in Erlang can handle more than two million connections on a single server in a real production application, with memory and CPU to spare!

The Web is concurrent, and Erlang is a language designed for concurrency, so it is a perfect match.

## Why Elixir matters for the Ingress architecture

Every single HTTP request against Ingress will create a new Erlang process. This means that every single request will be concurrently processed.

Apart from a bit of pre work, most of the request time in Ingress will be spent in waiting, Ingress sends the request to the presentation layer which will do the hard job of transforming the request into a full page, then Ingress will send it back to the user. 
Concurrency allow us to have processes on hold, waiting for their pages while leaving the server free to handle other incoming requests.

![](https://d2mxuefqeaa7sj.cloudfront.net/s_597D568B71C1719AF6004629DE6055CDF1335896E4BB3C9AB9432D233E8E245B_1552558055231_ingress+zzz.png)
