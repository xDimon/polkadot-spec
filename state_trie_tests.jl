include("./fixtures/test_fixtures.jl")
using Test
using Debugger
@testset "State Trie Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    cd(root_dir)
    for trie_data_file in StateTrieFixtures.test_trie_files
        test_result_array = []
        for cli_encoder in CommonFixtures.cli_testers
            state_data_file_full_path = join(["\"", script_dir, "/", StateTrieFixtures.fixture_data_dir,"/", String(trie_data_file), "\""])
            cmdparams = [cli_encoder, StateTrieFixtures.state_trie_test_command, StateTrieFixtures.state_trie_root_subcommand,  " --state-file ", state_data_file_full_path]
            cmd = join(cmdparams)
            push!(test_result_array, read(`sh -c $cmd`, String))
            println(test_result_array[end])

            if cli_encoder != CommonFixtures.cli_testers[CommonFixtures.reference_implementation]
                @test test_result_array[end] == test_result_array[CommonFixtures.reference_implementation]
            end

        end
    end

end
