// ------------------------------
// License
//
// Copyright 2024 Aldrin Montana
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


// ------------------------------
// Dependencies

#include <iostream>
#include <fstream>

#include "duckdb.hpp"
#include "substrait_extension.hpp"


// ------------------------------
// Aliases

using duckdb::unique_ptr;
using duckdb::vector;
using duckdb::string;

using duckdb::DuckDB;
using duckdb::Connection;
using duckdb::QueryResult;
using duckdb::DataChunk;
using duckdb::ErrorData;
using duckdb::Value;


// ------------------------------
// Global variables

static const char* db_fpath   = "/Users/octalene/code/mohair-experiments/resources/data/testdb";
static const char* test_query = (
  "  SELECT  gene_id"
  "         ,COUNT(*)        AS cell_count"
  "         ,AVG(e.expr)     AS expr_avg"
  "         ,VAR_POP(e.expr) AS expr_var"
  "    FROM metaclusters mc"

  "          JOIN clusters c"
  "         USING (cluster_id)"

  "          JOIN cluster_membership cm"
  "         USING (cluster_id)"

  "          JOIN  expression e"
  "         USING (cell_id)"

  "   WHERE mc.mcluster_id = 12"

  "GROUP BY e.gene_id"   
);


// ------------------------------
// Functions

int ViewQueryResults(unique_ptr<QueryResult> result_set) {
  ErrorData             result_err;
  unique_ptr<DataChunk> result_chunk { nullptr };

  do {
    if (not result_set->TryFetch(result_chunk, result_err)) {
      std::cerr << result_err.Message() << std::endl;
      return 2;
    }

    if (result_chunk) {
      std::cout << result_chunk->ToString() << std::endl;
    }
  }
  while (result_chunk != nullptr);

  return 0;
}


// ------------------------------
// Main logic

int main(int argc, char **argv) {
  // "Connect" to database and load extension
  DuckDB testdb { db_fpath };
  testdb.LoadExtension<duckdb::SubstraitExtension>();
  if (not testdb.ExtensionIsLoaded("substrait")) {
    std::cerr << "Could not load Substrait extension" << std::endl;
  }
  
  // Create a connection through which we can send requests
  Connection duck_conn { testdb   };

  // Produce substrait from SQL
  string plan_msg { duck_conn.GetSubstrait(test_query) };

  // Translate substrait to physical plan
  vector<Value> fn_args { Value::BLOB_RAW(plan_msg) };
  unique_ptr<QueryResult> result = duck_conn.TableFunction("translate_mohair", fn_args)->Execute();

  return ViewQueryResults(std::move(result));
}
