def normalize_text(text):
    lines = text.lstrip('\n').rstrip(' ').rstrip('\n').split('\n')
    leading_spaces = len(lines[0]) - len(lines[0].lstrip(' '))

    processed_lines = [line[leading_spaces:] for line in lines]
    normalized_text = '\n'.join(processed_lines)

    return normalized_text


def linkify(link):
    return f"[{link}]({link})"
