The default behaviour of the RDB is to collect data to an in-memory database during the day and then to save it to disk as an historical partition at day end. This makes sense if it’s actually queried during the day – but if the only reason for having an RDB is to be able to save the historical partition the amount of memory required to keep the in-memory database can be excessive.

<i class="fa fa-github"></i> [simongarland/tick/w.q](https://github.com/simongarland/tick/blob/master/w.q) is a potential replacement for the default RDB <i class="fa fa-github"></i> [KxSystems/kdb/tick](https://github.com/KxSystems/kdb/tree/master/tick).

w.q connects to the tickerplant just like r.q, but it buffers up requests and, every `MAXROWS` records, writes the data to disk. At day end remaining data is flushed to disk, the database is sorted (on disk) and then moved to the appropriate date partition within the historical database.

Note that it makes no sense to query the task running w.q as it will have a small (and variable-sized) selection of records. Although it wouldn’t be difficult to modify it to keep say the last 5 minutes of data, that sort of custom collection is probably better housed in a task running a c.q-like aggregation.

Syntax:
```
/ q tick/w.q [tickerplanthost]:port[:usr:pwd] [hdbhost]:port[:usr:pwd] [-koe|keeponexit]
```
```q
q tick/w.q :5010 :5012
```
The `-koe` or `-keeponexit` parameter governs the behaviour when a w.q task is exited at user request – i.e. `.z.exit` is called. By default the data saved so far is deleted, as if the task were restarted it would be difficult to ensure it restarted from exactly the right place – it’s easier to replay the log and (re)write the data. If the flag is provided – or the `KEEPONEXIT` global set to `1b` – the data will not be removed.
