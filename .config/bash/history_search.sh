#!/bin/bash

historyFZF ()
{
    history | sort --reverse --numeric-sort | fzf
}
