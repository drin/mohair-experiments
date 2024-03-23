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

#include <fstream>

#include "duckdb.hpp"
#include "substrait_extension.hpp"


// ------------------------------
// Global variables

static const char* plan_fpath = "./resources/examples/query.substrait";
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

/** Given a file path, return a binary input stream. */
std::ofstream StreamForFile(const char *out_fpath) {
  return std::ofstream { out_fpath, std::ios::out | std::ios::binary };
}


// ------------------------------
// Main logic

int main(int argc, char **argv) {
  duckdb::DuckDB     testdb    { db_fpath };
  duckdb::Connection duck_conn { testdb   };

  std::string plan_msg { duck_conn.GetSubstrait(test_query) };

  std::ofstream output_handle { StreamForFile(plan_fpath) };
  output_handle << plan_msg;

  return 0;
}

// ------------------------------
// Notes

/**
 * Loading an extension has 2 approaches, but the duckdb-substrait repo autoloads
 * substrait when building.
 *
 * The direct approach:
 *    duckdb::SubstraitExtension ext_duckstrait;
 *    ext_duckstrait.Load(testdb);
 *
 *  And the convenient approach (which just wraps the direct approach):
 *      testdb.LoadExtension<duckdb::SubstraitExtension>();
 */
