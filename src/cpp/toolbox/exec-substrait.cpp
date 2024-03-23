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

static const char* plan_fpath = "./resources/examples/query.substrait";
static const char* db_fpath   = "/Users/octalene/code/mohair-experiments/resources/data/testdb";


// ------------------------------
// Functions

/** Given a file path, return a binary input stream. */
std::ifstream StreamForFile(const char *in_fpath) {
  return std::ifstream { in_fpath, std::ios::in | std::ios::binary };
}

/** Given a file path, read the file data as binary into an output string. */
bool FileToString(const char *in_fpath, std::string &file_data) {
  // create an IO stream for the file
  auto file_stream = StreamForFile(in_fpath);
  if (!file_stream) {
    std::cerr << "Failed to open IO stream for file" << std::endl;
    return false;
  }

  // go to end of stream, read the position, then reset position
  file_stream.seekg(0, std::ios_base::end);
  auto size = file_stream.tellg();
  file_stream.seekg(0);
  std::cout << "File size: [" << std::to_string(size) << "]" << std::endl;

  // Resize the output and read the file data into it
  file_data.resize(size);
  auto output_ptr = &(file_data[0]);
  file_stream.read(output_ptr, size);

  // On success, the number of characters read will match size
  return file_stream.gcount() == size;
}

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
  duckdb::DuckDB     testdb    { db_fpath };
  duckdb::Connection duck_conn { testdb   };

  std::string plan_msg;
  if (not FileToString(plan_fpath, plan_msg)) {
    std::cerr << "Unable to read plan message from file" << std::endl;
    return 1;
  }

  duckdb::unique_ptr<duckdb::QueryResult> result = duck_conn.FromSubstrait(plan_msg);

  return ViewQueryResults(std::move(result));
}
