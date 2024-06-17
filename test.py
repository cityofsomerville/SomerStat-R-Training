import tiktoken

def count_chatgpt_tokens(text: str) -> int:
    """
    Calculates the number of ChatGPT tokens in the given string.

    Args:
        text: The string to analyze.

    Returns:
        The number of ChatGPT tokens in the string.
    """

    encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
    tokens = encoding.encode(text)
    return len(tokens)

# Example usage
text_to_analyze = "This is a sample sentence to count tokens."
token_count = count_chatgpt_tokens(text_to_analyze)
print(f"The text contains {token_count} ChatGPT tokens.")

        